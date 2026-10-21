from datetime import datetime
import os
import random
import uuid
from flask import (
    Flask,
    redirect,
    render_template_string,
    request,
    session,
    url_for,
)
import requests
from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.secret_key = os.urandom(32)

UPLOAD_FOLDER = "uploads"
ALLOWED_EXTENSIONS = {"txt", "lua", "png", "jpg", "jpeg", "mp3", "wav"}
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["MAX_CONTENT_LENGTH"] = 20 * 1024 * 1024  # 20 MB

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

users_db = {}
scripts_db = {}


def allowed_file(filename):
    return (
        "." in filename
        and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS
    )


# --- 3-LAYER HYBRID OBFUSCATION SYSTEM ---
def obfuscate_layer_3_core(code):
    byte_array = [ord(c) for c in code]
    return f"local _CORE = {{{','.join(map(str, byte_array))}}}; local _run = function(t) local s='' for _,v in ipairs(t) do s=s..string.char(v) end return s end; loadstring(_run(_CORE))()"


def obfuscate_layer_2_middle(code):
    anti_dump = "if not game or not game.HttpGet then return end\n"
    return anti_dump + obfuscate_layer_3_core(code)


def obfuscator_master(code):
    layer2 = obfuscate_layer_2_middle(code)
    chunk_size = 12
    chunks = [
        layer2[i : i + chunk_size] for i in range(0, len(layer2), chunk_size)
    ]
    indices = list(range(len(chunks)))
    shuffled = indices.copy()
    random.shuffle(shuffled)
    shuffled_chunks = [chunks[i] for i in shuffled]

    script = f"""
    local _F = {{ {','.join([f'[{i+1}]="{shuffled_chunks[i]}"' for i in range(len(shuffled_chunks))])} }}
    local _MAP = {{ {','.join([str(idx+1) for idx in shuffled])} }}
    local _S = ""
    for _, orig_idx in ipairs(_MAP) do
        _S = _S .. _F[orig_idx]
    end
    loadstring(_S)()
    """
    return script


# --- HTML TEMPLATES (EMBEDDED PREMIUM DESIGN) ---
BASE_LAYOUT = """
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>APEXON x</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #0b0b0e; color: #f3f4f6; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .glass-card { background: rgba(20, 20, 25, 0.75); backdrop-filter: blur(12px); border: 1px solid rgba(255, 0, 51, 0.25); }
        .btn-primary { background: linear-gradient(135deg, #ff0033 0%, #99001f 100%); transition: all 0.3s ease; }
        .btn-primary:hover { opacity: 0.9; transform: translateY(-1px); box-shadow: 0 4px 20px rgba(255, 0, 51, 0.4); }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <header class="border-b border-red-900/30 bg-[#0f0f13]/90 backdrop-blur sticky top-0 z-50 px-6 py-4 flex justify-between items-center">
        <a href="/" class="text-2xl font-black tracking-wider text-red-600 flex items-center gap-2">
            <i class="fa-solid fa-code"></i> APEXON <span class="text-white text-sm bg-red-600 px-2 py-0.5 rounded">x</span>
        </a>
        <div class="flex items-center gap-4">
            {% if 'username' in session %}
                <div class="relative">
                    <button onclick="toggleMenu()" class="flex items-center gap-2 bg-zinc-900 border border-red-600/50 px-4 py-2 rounded-xl text-sm font-semibold hover:border-red-500 transition">
                        <i class="fa-solid fa-user-shield text-red-500"></i> {{ session['username'] }} <i class="fa-solid fa-chevron-down text-xs ml-1"></i>
                    </button>
                    <div id="navMenu" class="hidden absolute right-0 mt-2 w-56 glass-card rounded-2xl shadow-2xl py-2 z-50 border border-zinc-800">
                        <a href="/profile" class="block px-4 py-2.5 text-sm hover:bg-red-600/20 hover:text-red-400 transition"><i class="fa-solid fa-user mr-2"></i> 1. โปรไฟล์</a>
                        <a href="/upload" class="block px-4 py-2.5 text-sm hover:bg-red-600/20 hover:text-red-400 transition"><i class="fa-solid fa-upload mr-2"></i> 2. อัปโหลด</a>
                        <a href="/customize" class="block px-4 py-2.5 text-sm hover:bg-red-600/20 hover:text-red-400 transition"><i class="fa-solid fa-paint-brush mr-2"></i> 3. ตกแต่งโปรไฟล์</a>
                        <a href="/support" class="block px-4 py-2.5 text-sm hover:bg-red-600/20 hover:text-red-400 transition"><i class="fa-solid fa-mug-hot mr-2"></i> 4. สนับสนุน</a>
                        <div class="border-t border-zinc-800 my-1"></div>
                        <a href="/logout" class="block px-4 py-2.5 text-sm text-red-400 hover:bg-red-600/20 transition"><i class="fa-solid fa-right-from-bracket mr-2"></i> 5. ลงชื่อออก</a>
                    </div>
                </div>
            {% else %}
                <div class="flex gap-3">
                    <a href="/login" class="px-5 py-2 rounded-xl text-sm font-bold border border-zinc-700 hover:border-red-600 transition">เข้าสู่ระบบ</a>
                    <a href="/register" class="btn-primary px-5 py-2 rounded-xl text-sm font-bold text-white shadow-lg shadow-red-600/30">สมัครสมาชิก</a>
                </div>
            {% endif %}
        </div>
    </header>
    <main class="flex-grow max-w-4xl w-full mx-auto px-4 py-8">
        {{ content | safe }}
    </main>
    <script>
        function toggleMenu() {
            document.getElementById('navMenu').classList.toggle('hidden');
        }
    </script>
</body>
</html>
"""


@app.route("/")
def index():
    content = """
    <div class="text-center py-20 glass-card rounded-3xl p-8 border border-red-900/40 shadow-2xl relative overflow-hidden">
        <span class="bg-red-600/20 text-red-500 text-xs font-bold px-3 py-1 rounded-full uppercase tracking-widest border border-red-500/30">Secure Script Hosting & Obfuscator</span>
        <h1 class="text-4xl md:text-6xl font-black mt-4 tracking-tight">APEXON <span class="text-red-600">x</span></h1>
        <p class="text-zinc-400 mt-3 max-w-lg mx-auto text-sm">แพลตฟอร์มฝากโค้ดพร้อมระบบซ่อนโค้ด 3 ชั้น และหน้าโปรไฟล์ Bio สไตล์พรีเมียม</p>
        <div class="mt-8 flex justify-center gap-4">
            <a href="/upload" class="btn-primary px-8 py-3 rounded-xl font-bold text-white shadow-lg shadow-red-600/40">เริ่มต้นใช้งาน</a>
        </div>
    </div>
    """
    return render_template_string(BASE_LAYOUT.replace("{{ content | safe }}", content))


@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        confirm_pass = request.form.get("confirm_password")

        if password != confirm_pass:
            return "<script>alert('รหัสผ่านไม่ตรงกัน!'); window.history.back();</script>"
        if (
            len(password) < 8
            or not any(c.isupper() for c in password)
            or not any(c.islower() for c in password)
            or not any(c.isdigit() for c in password)
            or not any(not c.isalnum() for c in password)
        ):
            return "<script>alert('รหัสผ่านต้องมีอย่างน้อย 8 ตัว มีพิมพ์ใหญ่ พิมพ์เล็ก ตัวเลข และอักษรพิเศษ!'); window.history.back();</script>"
        if username in users_db:
            return "<script>alert('ชื่อผู้ใช้นี้ถูกใช้งานแล้ว!'); window.history.back();</script>"

        users_db[username] = {
            "password": generate_password_hash(password),
            "banner": "",
            "theme": "#ff0033",
        }
        return redirect(url_for("login"))

    content = """
    <div class="max-w-md mx-auto glass-card p-8 rounded-3xl border border-red-900/30 shadow-2xl">
        <h2 class="text-2xl font-black text-white mb-6">สมัครสมาชิก</h2>
        <form method="POST" class="space-y-4">
            <div><label class="block text-xs font-bold text-zinc-400 mb-1">ชื่อผู้ใช้</label><input type="text" name="username" required class="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white focus:border-red-600"></div>
            <div><label class="block text-xs font-bold text-zinc-400 mb-1">รหัสผ่าน (>= 8 ตัว, พิมพ์ใหญ่, เล็ก, ตัวเลข, สัญลักษณ์)</label><input type="password" name="password" required class="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white focus:border-red-600"></div>
            <div><label class="block text-xs font-bold text-zinc-400 mb-1">ยืนยันรหัสผ่าน</label><input type="password" name="confirm_password" required class="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white focus:border-red-600"></div>
            <button type="submit" class="btn-primary w-full py-3 rounded-xl font-bold text-white mt-2">ลงชื่อเข้าใช้</button>
        </form>
    </div>
    """
    return render_template_string(BASE_LAYOUT.replace("{{ content | safe }}", content))


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        user = users_db.get(username)
        if user and check_password_hash(user["password"], password):
            session["username"] = username
            return redirect(url_for("index"))
        return "<script>alert('ชื่อหรือรหัสผ่านไม่ถูกต้อง!'); window.history.back();</script>"

    content = """
    <div class="max-w-md mx-auto glass-card p-8 rounded-3xl border border-red-900/30 shadow-2xl">
        <h2 class="text-2xl font-black text-white mb-6">เข้าสู่ระบบ</h2>
        <form method="POST" class="space-y-4">
            <div><label class="block text-xs font-bold text-zinc-400 mb-1">ชื่อผู้ใช้</label><input type="text" name="username" required class="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white focus:border-red-600"></div>
            <div><label class="block text-xs font-bold text-zinc-400 mb-1">รหัสผ่าน</label><input type="password" name="password" required class="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white focus:border-red-600"></div>
            <button type="submit" class="btn-primary w-full py-3 rounded-xl font-bold text-white mt-2">เข้าสู่ระบบ</button>
        </form>
    </div>
    """
    return render_template_string(BASE_LAYOUT.replace("{{ content | safe }}", content))


@app.route("/logout")
def logout():
    session.pop("username", None)
    return redirect(url_for("index"))


@app.route("/upload", methods=["GET", "POST"])
def upload():
    if "username" not in session:
        return redirect(url_for("login"))
    if request.method == "POST":
        title = request.form.get("title", "Untitled")
        code_text = request.form.get("code_text", "")
        file = request.files.get("file")

        content = code_text
        if file and file.filename != "" and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            with open(
                os.path.join(app.config["UPLOAD_FOLDER"], filename),
                "r",
                encoding="utf-8",
                errors="ignore",
            ) as f:
                content = f.read()

        # ทำการ Obfuscate โค้ด 3 ชั้นอัตโนมัติก่อนบันทึก
        protected_content = obfuscator_master(content)

        raw_id = uuid.uuid4().hex[:8]
        scripts_db[raw_id] = {
            "username": session["username"],
            "title": title,
            "content": protected_content,
        }
        raw_link = f'loadstring(game:HttpGet("https://APEXONx.com/raw/{session["username"]}/{raw_id}"))()'

        content_success = f"""
        <div class="max-w-xl mx-auto glass-card p-8 rounded-3xl border border-red-900/30 text-center shadow-2xl">
            <h2 class="text-2xl font-black text-white mb-2">สร้าง Raw สำเร็จ! (ป้องกัน 3 ชั้นแล้ว)</h2>
            <div class="bg-zinc-900 border border-zinc-800 rounded-xl p-3 flex items-center gap-2 my-6">
                <input type="text" value='{raw_link}' readonly id="rawBox" class="bg-transparent text-zinc-300 text-xs w-full focus:outline-none font-mono">
                <button onclick="navigator.clipboard.writeText(document.getElementById('rawBox').value); alert('คัดลอกลิงก์แล้ว!');" class="btn-primary px-4 py-2 rounded-lg text-xs font-bold text-white shrink-0">คัดลอก</button>
            </div>
            <a href="/profile" class="btn-primary px-6 py-2.5 rounded-xl font-bold text-white text-sm inline-block">ไปยังโปรไฟล์</a>
        </div>
        """
        return render_template_string(
            BASE_LAYOUT.replace("{{ content | safe }}", content_success)
        )

    content = """
    <div class="max-w-2xl mx-auto glass-card p-8 rounded-3xl border border-red-900/30 shadow-2xl">
        <h2 class="text-2xl font-black text-white mb-6">อัปโหลดและสร้าง Raw</h2>
        <form method="POST" enctype="multipart/form-data" class="space-y-5">
            <div><label class="block text-xs font-bold text-zinc-400 mb-1">ชื่อสคริปต์</label><input type="text" name="title" required class="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white"></div>
            <div><label class="block text-xs font-bold text-zinc-400 mb-1">วางโค้ด Luau</label><textarea name="code_text" rows="8" class="w-full bg-zinc-900 border border-zinc-800 rounded-xl p-4 text-white font-mono text-sm"></textarea></div>
            <div><label class="block text-xs font-bold text-zinc-400 mb-1">หรืออัปโหลดไฟล์ (.lua, .txt ไม่เกิน 20MB)</label><input type="file" name="file" class="w-full bg-zinc-900 border border-zinc-800 rounded-xl p-3 text-sm text-zinc-400"></div>
            <button type="submit" class="btn-primary w-full py-3.5 rounded-xl font-bold text-white shadow-lg">สร้าง Raw Link & Obfuscate</button>
        </form>
    </div>
    """
    return render_template_string(BASE_LAYOUT.replace("{{ content | safe }}", content))


@app.route("/raw/<username>/<raw_id>")
def raw_view(username, raw_id):
    script = scripts_db.get(raw_id)
    if not script:
        return "-- Script not found", 404
    user_agent = request.headers.get("User-Agent", "")
    if "Roblox" not in user_agent and "RobloxStudio" not in user_agent:
        return redirect(url_for("public_profile", username=username))
    return script["content"], 200, {"Content-Type": "text/plain; charset=utf-8"}


@app.route("/profile")
def profile():
    if "username" not in session:
        return redirect(url_for("login"))
    username = session["username"]
    user_scripts = {
        rid: data
        for rid, data in scripts_db.items()
        if data["username"] == username
    }

    scripts_html = ""
    for rid, data in user_scripts.items():
        scripts_html += f"""
        <div class="bg-zinc-900 border border-zinc-800 rounded-2xl p-4 flex justify-between items-center my-3">
            <div><h4 class="font-bold text-white">{data['title']}</h4><p class="text-xs text-zinc-500 font-mono">ID: {rid}</p></div>
            <div class="flex gap-2">
                <a href="https://APEXONx.com/raw/{username}/{rid}" target="_blank" class="bg-zinc-800 px-4 py-2 rounded-xl text-xs font-bold text-zinc-300">คัดลอกraw</a>
                <a href="/delete/{rid}" class="bg-red-600/20 text-red-500 px-4 py-2 rounded-xl text-xs font-bold">ลบ</a>
            </div>
        </div>
        """

    content = f"""
    <div class="glass-card p-6 rounded-3xl border border-red-900/30 mb-8">
        <h2 class="text-2xl font-black text-white">{username}</h2>
        <p class="text-zinc-400 text-xs">จัดการไฟล์สคริปต์ของคุณ</p>
    </div>
    <div class="glass-card p-6 rounded-3xl border border-red-900/30">
        <h3 class="text-lg font-bold text-white mb-4">สคริปต์ทั้งหมด</h3>
        {scripts_html if user_scripts else '<p class="text-zinc-500 text-sm">ยังไม่มีไฟล์</p>'}
    </div>
    """
    return render_template_string(BASE_LAYOUT.replace("{{ content | safe }}", content))


@app.route("/public_profile/<username>")
def public_profile(username):
    user = users_db.get(username)
    if not user:
        return "ไม่พบผู้ใช้นี้", 404
    content = f"""
    <div class="max-w-md mx-auto glass-card rounded-3xl p-8 border border-red-900/40 text-center shadow-2xl" style="border-top: 4px solid {user['theme']};">
        <h1 class="text-2xl font-black text-white">{username}</h1>
        <p class="text-xs text-zinc-400 mt-1">Verified Developer on APEXON x</p>
    </div>
    """
    return render_template_string(BASE_LAYOUT.replace("{{ content | safe }}", content))


@app.route("/customize", methods=["GET", "POST"])
def customize():
    if "username" not in session:
        return redirect(url_for("login"))
    if request.method == "POST":
        users_db[session["username"]]["banner"] = request.form.get("banner_url")
        users_db[session["username"]]["theme"] = request.form.get(
            "theme_color", "#ff0033"
        )
        return "<script>alert('บันทึกเรียบร้อย!'); window.location.href='/profile';</script>"

    content = """
    <div class="max-w-xl mx-auto glass-card p-8 rounded-3xl border border-red-900/30 shadow-2xl">
        <h2 class="text-2xl font-black text-white mb-6">ตกแต่งโปรไฟล์</h2>
        <form method="POST" class="space-y-6">
            <div><label class="block text-xs font-bold text-zinc-400 mb-1">Banner URL</label><input type="text" name="banner_url" class="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white"></div>
            <div><label class="block text-xs font-bold text-zinc-400 mb-1">สีธีมโปรไฟล์</label><input type="color" name="theme_color" value="#ff0033" class="w-16 h-12 bg-zinc-900 border border-zinc-800 rounded-xl p-1"></div>
            <button type="submit" class="btn-primary w-full py-3.5 rounded-xl font-bold text-white shadow-lg">บันทึกการเปลี่ยนแปลง</button>
        </form>
    </div>
    """
    return render_template_string(BASE_LAYOUT.replace("{{ content | safe }}", content))


@app.route("/support", methods=["GET", "POST"])
def support():
    if "username" not in session:
        return redirect(url_for("login"))
    if request.method == "POST":
        angpao = request.form.get("angpao_link")
        webhook_url = "https://discord.com/api/webhooks/1562427818527297568/pWes8hL1jLu3zboiYFYLSoGrC-qVn1WwZbf76nXvgL6dOI_wyl-3FD385QOr0nOSxMIH"
        payload = {
            "content": f"📢 **มีผู้สนับสนุนใหม่!**\n- **ผู้ใช้:** {session['username']}\n- **ซองอังเปา:** {angpao}\n- **เวลา:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
        }
        try:
            requests.post(webhook_url, json=payload)
        except:
            pass
        return "<script>alert('ส่งข้อมูลสำเร็จ!'); window.location.href='/support';</script>"

    content = """
    <div class="max-w-xl mx-auto glass-card p-8 rounded-3xl border border-red-900/30 shadow-2xl text-center">
        <h2 class="text-2xl font-black text-white mb-6">สนับสนุนผู้พัฒนา</h2>
        <div class="bg-zinc-900 border border-zinc-800 rounded-2xl p-6 mb-6 inline-block">
            <div class="w-48 h-48 bg-zinc-950 border-2 border-red-600/50 rounded-xl flex items-center justify-center text-red-500 font-bold mx-auto">[ QR CODE ]</div>
        </div>
        <form method="POST" class="space-y-4 text-left">
            <div><label class="block text-xs font-bold text-zinc-400 mb-1">ลิงก์ซองอังเปา TrueMoney Wallet</label><input type="text" name="angpao_link" required class="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-4 py-3 text-white"></div>
            <button type="submit" class="btn-primary w-full py-3.5 rounded-xl font-bold text-white shadow-lg">ยืนยันการสนับสนุน</button>
        </form>
    </div>
    """
    return render_template_string(BASE_LAYOUT.replace("{{ content | safe }}", content))


@app.route("/delete/<raw_id>")
def delete_script(raw_id):
    if "username" in session and raw_id in scripts_db:
        if scripts_db[raw_id]["username"] == session["username"]:
            del scripts_db[raw_id]
    return redirect(url_for("profile"))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
