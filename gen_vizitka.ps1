$portfolioPath = "C:\Users\marga\Documents\Projects\first projects\portfolio"
$outputPath    = "C:\Users\marga\Documents\Projects\first projects\vizitka.html"

$catDefs = @(
    @{key="voennye";       label="Военные фото";   type="photo"},
    @{key="portrety";      label="Портреты";        type="photo"},
    @{key="priroda";       label="Природа";         type="photo"},
    @{key="flagi";         label="Флаги";           type="photo"},
    @{key="video-realism"; label="Видео — реализм"; type="video"},
    @{key="video-cartoon"; label="Видео — мульт";   type="video"}
)

function Get-Mime($ext) {
    switch ($ext.ToLower()) {
        {$_ -in @(".jpg",".jpeg")} { return "image/jpeg" }
        ".png"  { return "image/png"  }
        ".webp" { return "image/webp" }
        ".mp4"  { return "video/mp4"  }
        ".webm" { return "video/webm" }
        ".mov"  { return "video/mp4"  }
        default { return "image/jpeg" }
    }
}

Write-Host "Открываю поток записи..."
$sw = [System.IO.StreamWriter]::new($outputPath, $false, [System.Text.Encoding]::UTF8)

# ═══════════════ ЧАСТЬ 1: HTML + CSS ═══════════════
$sw.Write(@'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Маргарита Антонова — AI Визуал</title>
    <style>
        :root {
            --bg:     #03040e;
            --accent: #c084fc;
            --accent2:#818cf8;
            --sky:    #38bdf8;
            --text:   #e2e8f0;
            --muted:  #64748b;
            --card:   rgba(255,255,255,0.03);
            --border: rgba(255,255,255,0.07);
        }
        *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }
        html { scroll-behavior:smooth; }
        body {
            background: var(--bg);
            color: var(--text);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
        }
        body::before {
            content: '';
            position: fixed; inset: 0; z-index: 0; pointer-events: none;
            background:
                radial-gradient(ellipse 70% 55% at 12% 20%, rgba(70,20,130,0.25) 0%, transparent 70%),
                radial-gradient(ellipse 55% 45% at 88% 75%, rgba(15,45,110,0.2)  0%, transparent 65%),
                radial-gradient(ellipse 40% 60% at 55% 48%, rgba(40,10,70,0.13)  0%, transparent 70%),
                radial-gradient(ellipse 30% 28% at 72% 12%, rgba(90,25,60,0.12)  0%, transparent 60%);
        }
        #stars { position:fixed; inset:0; pointer-events:none; z-index:0; }
        .container { max-width:920px; margin:0 auto; padding:0 24px; position:relative; z-index:1; }

        /* HERO */
        .hero {
            min-height:100vh; display:flex; flex-direction:column;
            justify-content:center; align-items:center; text-align:center;
            padding:80px 20px 100px; position:relative;
        }
        .avatar-ring {
            width:130px; height:130px; border-radius:50%;
            background:conic-gradient(from 0deg,#c084fc,#818cf8,#38bdf8,#c084fc);
            padding:3px; margin-bottom:36px;
            animation:ring-spin 8s linear infinite; flex-shrink:0;
        }
        .avatar-core {
            width:100%; height:100%; border-radius:50%;
            background:#03040e; display:flex; align-items:center; justify-content:center;
            font-size:52px; font-weight:900;
            background-image:linear-gradient(135deg,#c084fc,#38bdf8);
            -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text;
        }
        @keyframes ring-spin { to { transform:rotate(360deg); } }
        .name {
            font-size:clamp(2.8rem,9vw,5.5rem); font-weight:900;
            line-height:1.05; letter-spacing:-1px;
            background:linear-gradient(135deg,#e0c3fc 0%,#c084fc 25%,#818cf8 55%,#38bdf8 80%,#e0c3fc 100%);
            background-size:300% 300%;
            -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text;
            animation:name-shift 6s ease-in-out infinite;
            filter:drop-shadow(0 0 40px rgba(192,132,252,0.45)); margin-bottom:14px;
        }
        @keyframes name-shift {
            0%  { background-position:0% 50%; }
            50% { background-position:100% 50%; }
            100%{ background-position:0% 50%; }
        }
        .subtitle { font-size:0.78rem; letter-spacing:4px; text-transform:uppercase; color:var(--muted); margin-bottom:32px; }
        .chips { display:flex; flex-wrap:wrap; gap:10px; justify-content:center; margin-bottom:44px; }
        .chip {
            padding:7px 18px; border-radius:100px; border:1px solid var(--border);
            background:var(--card); font-size:0.82rem; backdrop-filter:blur(12px);
            transition:all 0.3s; cursor:default;
        }
        .chip:hover { border-color:rgba(192,132,252,0.45); background:rgba(192,132,252,0.1); transform:translateY(-3px); }
        .socials { display:flex; gap:14px; justify-content:center; margin-bottom:36px; }
        .s-btn {
            width:54px; height:54px; border-radius:50%; background:var(--card);
            border:1px solid var(--border); display:flex; align-items:center; justify-content:center;
            text-decoration:none; color:var(--text);
            transition:all 0.35s cubic-bezier(0.34,1.56,0.64,1);
            backdrop-filter:blur(12px); position:relative;
        }
        .s-btn svg { width:24px; height:24px; fill:currentColor; }
        .s-btn:hover { transform:translateY(-6px) scale(1.12); border-color:rgba(192,132,252,0.6); background:rgba(192,132,252,0.13); box-shadow:0 12px 32px rgba(192,132,252,0.3); color:#c084fc; }
        .s-label { position:absolute; bottom:-22px; left:50%; transform:translateX(-50%); font-size:0.65rem; color:var(--muted); white-space:nowrap; opacity:0; transition:opacity 0.2s; }
        .s-btn:hover .s-label { opacity:1; }
        .btn-contact {
            position:relative; display:inline-flex; align-items:center; gap:10px;
            padding:17px 38px; border-radius:100px;
            background:linear-gradient(135deg,#c084fc,#818cf8);
            color:#fff; text-decoration:none; font-weight:700; font-size:1rem;
            overflow:hidden; transition:transform 0.3s,box-shadow 0.3s; margin-top:10px;
        }
        .btn-contact::after { content:''; position:absolute; inset:0; background:linear-gradient(135deg,#818cf8,#38bdf8); opacity:0; transition:opacity 0.35s; }
        .btn-contact:hover::after { opacity:1; }
        .btn-contact:hover { transform:translateY(-4px); box-shadow:0 20px 50px rgba(192,132,252,0.45); }
        .btn-contact > * { position:relative; z-index:1; }
        .btn-contact svg { fill:#fff; }
        .btn-pulse { position:absolute; inset:0; border-radius:inherit; z-index:0; animation:pulse 2.5s ease-out infinite; }
        @keyframes pulse { 0%{box-shadow:0 0 0 0 rgba(192,132,252,0.55);} 70%{box-shadow:0 0 0 18px rgba(192,132,252,0);} 100%{box-shadow:0 0 0 0 rgba(192,132,252,0);} }
        .scroll-hint {
            position:absolute; bottom:28px; left:50%; transform:translateX(-50%);
            display:flex; flex-direction:column; align-items:center; gap:6px;
            color:var(--muted); font-size:0.72rem; letter-spacing:2px; text-transform:uppercase;
            animation:float 2.2s ease-in-out infinite;
        }
        @keyframes float { 0%,100%{transform:translateX(-50%) translateY(0);} 50%{transform:translateX(-50%) translateY(9px);} }

        /* SECTIONS */
        .section { padding:90px 0; }
        .s-title { font-size:1.75rem; font-weight:800; margin-bottom:40px; display:inline-block; position:relative; }
        .s-title::after { content:''; position:absolute; bottom:-10px; left:0; width:36px; height:3px; border-radius:2px; background:linear-gradient(90deg,#c084fc,#38bdf8); }

        /* CATEGORY ACCORDION */
        .cat-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(300px,1fr)); gap:20px; }
        .cat-card { background:var(--card); border:1px solid var(--border); border-radius:20px; overflow:hidden; backdrop-filter:blur(14px); transition:border-color 0.3s,box-shadow 0.3s; cursor:pointer; }
        .cat-card:hover { border-color:rgba(192,132,252,0.3); box-shadow:0 16px 40px rgba(0,0,0,0.35); }
        .cat-card.open { border-color:rgba(192,132,252,0.4); box-shadow:0 20px 50px rgba(0,0,0,0.4); }
        .cat-head { display:flex; align-items:center; gap:16px; padding:24px 22px; position:relative; }
        .cat-head::before { content:''; position:absolute; top:0; left:0; right:0; height:2px; background:linear-gradient(90deg,#c084fc,#818cf8,#38bdf8); transform:scaleX(0); transform-origin:left; transition:transform 0.4s; }
        .cat-card.open .cat-head::before,.cat-card:hover .cat-head::before { transform:scaleX(1); }
        .cat-icon { width:56px; height:56px; border-radius:16px; background:rgba(192,132,252,0.1); display:flex; align-items:center; justify-content:center; font-size:28px; flex-shrink:0; transition:background 0.3s; }
        .cat-card.open .cat-icon,.cat-card:hover .cat-icon { background:rgba(192,132,252,0.18); }
        .cat-info { flex:1; }
        .cat-info h3 { font-size:1.1rem; font-weight:800; margin-bottom:4px; }
        .cat-info p  { font-size:0.82rem; color:var(--muted); }
        .cat-arr { width:32px; height:32px; border-radius:50%; border:1px solid var(--border); display:flex; align-items:center; justify-content:center; flex-shrink:0; transition:background 0.2s,border-color 0.2s; }
        .cat-arr svg { fill:var(--muted); transition:transform 0.35s,fill 0.2s; }
        .cat-card.open .cat-arr { background:rgba(192,132,252,0.1); border-color:rgba(192,132,252,0.4); }
        .cat-card.open .cat-arr svg { transform:rotate(180deg); fill:var(--accent); }
        .cat-body { max-height:0; overflow:hidden; transition:max-height 0.45s cubic-bezier(0.4,0,0.2,1); border-top:1px solid transparent; }
        .cat-card.open .cat-body { max-height:600px; border-top-color:var(--border); }
        .cat-body-inner { padding:20px 22px 24px; }
        .sub-item { display:flex; align-items:flex-start; gap:14px; padding:14px 0; border-bottom:1px solid var(--border); }
        .sub-item:last-child { border-bottom:none; padding-bottom:0; }
        .sub-item:first-child { padding-top:0; }
        .sub-ico { width:38px; height:38px; border-radius:10px; background:rgba(255,255,255,0.04); display:flex; align-items:center; justify-content:center; font-size:18px; flex-shrink:0; }
        .sub-item strong { display:block; font-size:0.9rem; font-weight:700; margin-bottom:3px; }
        .sub-item span   { font-size:0.8rem; color:var(--muted); line-height:1.5; }

        /* FILTERS */
        .filters { display:flex; flex-wrap:wrap; gap:8px; margin-bottom:28px; }
        .f-btn {
            padding:8px 18px; border-radius:100px; border:1px solid var(--border);
            background:var(--card); color:var(--muted); font-size:0.82rem;
            cursor:pointer; transition:all 0.25s; backdrop-filter:blur(8px); white-space:nowrap;
        }
        .f-btn:hover { border-color:rgba(192,132,252,0.4); color:var(--text); }
        .f-btn.active { background:linear-gradient(135deg,#c084fc,#818cf8); border-color:transparent; color:#fff; box-shadow:0 4px 15px rgba(192,132,252,0.35); }

        /* PORTFOLIO GRID */
        #grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:16px; margin-bottom:20px; }
        .p-item { aspect-ratio:1; border-radius:14px; overflow:hidden; border:1px solid var(--border); position:relative; cursor:pointer; background:var(--card); transition:transform 0.3s,box-shadow 0.3s; }
        .p-item:hover { transform:scale(1.04); box-shadow:0 14px 36px rgba(0,0,0,0.55); }
        .p-item img { width:100%; height:100%; object-fit:cover; display:block; transition:transform 0.4s; }
        .p-item:hover img { transform:scale(1.1); }
        .p-item video { width:100%; height:100%; object-fit:cover; display:block; }
        .p-item.p-video { aspect-ratio:16/9; grid-column:span 2; }
        .p-overlay { position:absolute; inset:0; background:rgba(0,0,0,0.45); display:flex; align-items:center; justify-content:center; opacity:0; transition:opacity 0.3s; }
        .p-item:hover .p-overlay { opacity:1; }
        .p-overlay svg { fill:#fff; }
        .p-empty { text-align:center; color:var(--muted); padding:60px 0; font-size:0.9rem; grid-column:1/-1; }

        /* LIGHTBOX */
        .lightbox { position:fixed; inset:0; background:rgba(0,0,0,0.96); z-index:9999; display:flex; align-items:center; justify-content:center; opacity:0; pointer-events:none; transition:opacity 0.3s; }
        .lightbox.open { opacity:1; pointer-events:all; }
        #lb-img {
            max-width:90vw; max-height:88vh; border-radius:12px; object-fit:contain;
            transform:scale(0.9); transition:transform 0.35s cubic-bezier(0.34,1.3,0.64,1); user-select:none; display:block;
        }
        .lightbox.open #lb-img { transform:scale(1); }
        #lb-video {
            max-width:90vw; max-height:88vh; border-radius:12px; display:none;
            transform:scale(0.9); transition:transform 0.35s cubic-bezier(0.34,1.3,0.64,1);
        }
        .lightbox.open #lb-video { transform:scale(1); }
        .lb-close { position:absolute; top:20px; right:20px; width:46px; height:46px; border-radius:50%; background:rgba(255,255,255,0.08); border:1px solid rgba(255,255,255,0.12); color:#fff; font-size:18px; cursor:pointer; display:flex; align-items:center; justify-content:center; transition:background 0.2s; z-index:10; }
        .lb-close:hover { background:rgba(255,255,255,0.18); }
        .lb-nav { position:absolute; top:50%; transform:translateY(-50%); width:46px; height:46px; border-radius:50%; background:rgba(255,255,255,0.08); border:1px solid rgba(255,255,255,0.12); color:#fff; font-size:20px; cursor:pointer; display:flex; align-items:center; justify-content:center; transition:background 0.2s; }
        .lb-nav:hover { background:rgba(255,255,255,0.18); }
        #lb-prev { left:16px; } #lb-next { right:16px; }

        /* DIVIDER + FOOTER */
        .divider { height:1px; background:linear-gradient(90deg,transparent,rgba(192,132,252,0.25),transparent); }
        footer { padding:40px 20px; text-align:center; color:var(--muted); font-size:0.8rem; border-top:1px solid var(--border); position:relative; z-index:1; }
        footer a { color:var(--muted); text-decoration:none; }
        footer a:hover { color:var(--accent); }

        @media (max-width:640px) {
            #grid { grid-template-columns:repeat(2,1fr); }
            .p-item.p-video { grid-column:span 2; aspect-ratio:16/9; }
            .cat-grid { grid-template-columns:1fr; }
            .lb-nav { display:none; }
            .filters { gap:6px; }
            .f-btn { font-size:0.75rem; padding:7px 14px; }
        }
        @media (max-width:400px) { #grid { grid-template-columns:1fr; } .p-item.p-video { grid-column:span 1; } }
    </style>
</head>
<body>

<canvas id="stars"></canvas>

<header class="hero">
    <div class="container" style="display:flex;flex-direction:column;align-items:center;">
        <div class="avatar-ring"><div class="avatar-core">М</div></div>
        <h1 class="name">Маргарита<br>Антонова</h1>
        <p class="subtitle">AI Визуал · Нейро-художник</p>
        <div class="chips">
            <span class="chip">📸 Нейрофото</span>
            <span class="chip">🎬 Нейровидео</span>
            <span class="chip">🚩 Флаги с позывными</span>
            <span class="chip">✨ AI-генерация</span>
        </div>
        <div class="socials">
            <a href="https://max.ru/join/DQJsHDoQ0rxT-gDAfz7WkXgN426ROLxWf-kTq69cXN8" target="_blank" rel="noopener" class="s-btn" title="Max.ru">
                <svg viewBox="0 0 24 24"><path d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2zm0 1.8a8.2 8.2 0 1 1 0 16.4A8.2 8.2 0 0 1 12 3.8zM7 8v8h1.8v-5.5l2.2 3 2.2-3V16H15V8h-1.8L11 11.2 8.8 8H7z"/></svg>
                <span class="s-label">Max.ru</span>
            </a>
        </div>
        <a href="mailto:margaritka15789@gmail.com" class="btn-contact">
            <div class="btn-pulse"></div>
            <svg viewBox="0 0 24 24" width="18" height="18"><path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4-8 5-8-5V6l8 5 8-5v2z"/></svg>
            <span>Написать мне</span>
        </a>
    </div>
    <div class="scroll-hint">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M7.41 8.59 12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"/></svg>
        <span>листать</span>
    </div>
</header>

<div class="divider"></div>

<section class="section">
    <div class="container">
        <h2 class="s-title">Что я создаю</h2>
        <div class="cat-grid">
            <div class="cat-card" onclick="toggleCat(this)">
                <div class="cat-head">
                    <div class="cat-icon">📸</div>
                    <div class="cat-info"><h3>Нейрофото</h3><p>Реалистичные AI-фотографии</p></div>
                    <div class="cat-arr"><svg viewBox="0 0 24 24" width="16" height="16"><path d="M7.41 8.59 12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"/></svg></div>
                </div>
                <div class="cat-body"><div class="cat-body-inner">
                    <div class="sub-item"><div class="sub-ico">🖼️</div><div><strong>Реалистичные снимки</strong><span>Портреты, пейзажи, любые сцены — гиперреализм любой атмосферы</span></div></div>
                    <div class="sub-item"><div class="sub-ico">⚔️</div><div><strong>Военные сцены</strong><span>Исторические и современные военные фото с детальной проработкой</span></div></div>
                    <div class="sub-item"><div class="sub-ico">🎨</div><div><strong>Разные стили</strong><span>Кино, нуар, фэнтези, sci-fi — любой визуальный стиль</span></div></div>
                </div></div>
            </div>
            <div class="cat-card" onclick="toggleCat(this)">
                <div class="cat-head">
                    <div class="cat-icon">🎬</div>
                    <div class="cat-info"><h3>Нейровидео</h3><p>AI-ролики и анимация</p></div>
                    <div class="cat-arr"><svg viewBox="0 0 24 24" width="16" height="16"><path d="M7.41 8.59 12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"/></svg></div>
                </div>
                <div class="cat-body"><div class="cat-body-inner">
                    <div class="sub-item"><div class="sub-ico">🎥</div><div><strong>Реалистичный стиль</strong><span>Кинематографичные нейроролики — фотореалистичные сцены</span></div></div>
                    <div class="sub-item"><div class="sub-ico">✏️</div><div><strong>Мультяшный стиль</strong><span>Анимация в cartoon/anime-стиле, яркая и характерная</span></div></div>
                    <div class="sub-item"><div class="sub-ico">⚡</div><div><strong>Нейроролики под заказ</strong><span>Короткие видео для соцсетей, рекламы и творческих проектов</span></div></div>
                </div></div>
            </div>
            <div class="cat-card" onclick="toggleCat(this)">
                <div class="cat-head">
                    <div class="cat-icon">🚩</div>
                    <div class="cat-info"><h3>Флаги с позывными</h3><p>Персональный дизайн</p></div>
                    <div class="cat-arr"><svg viewBox="0 0 24 24" width="16" height="16"><path d="M7.41 8.59 12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"/></svg></div>
                </div>
                <div class="cat-body"><div class="cat-body-inner">
                    <div class="sub-item"><div class="sub-ico">🎖️</div><div><strong>Индивидуальный дизайн</strong><span>Уникальные флаги с позывными — каждый создаётся персонально</span></div></div>
                    <div class="sub-item"><div class="sub-ico">🖌️</div><div><strong>Разные стили оформления</strong><span>Строгий, художественный, символичный — под характер и традиции</span></div></div>
                </div></div>
            </div>
        </div>
    </div>
</section>

<div class="divider"></div>

<section class="section">
    <div class="container">
        <h2 class="s-title">Мои работы</h2>
        <div class="filters">
            <button class="f-btn active" data-filter="all">Все работы</button>
            <button class="f-btn" data-filter="voennye">🪖 Военные</button>
            <button class="f-btn" data-filter="portrety">👤 Портреты</button>
            <button class="f-btn" data-filter="priroda">🌿 Природа</button>
            <button class="f-btn" data-filter="flagi">🚩 Флаги</button>
            <button class="f-btn" data-filter="video-realism">🎥 Видео — реализм</button>
            <button class="f-btn" data-filter="video-cartoon">✨ Видео — мульт</button>
        </div>
        <div id="grid"></div>
    </div>
</section>

<div class="lightbox" id="lightbox">
    <button class="lb-close" id="lb-close">✕</button>
    <button class="lb-nav" id="lb-prev">&#8249;</button>
    <img id="lb-img" src="" alt="preview">
    <video id="lb-video" controls></video>
    <button class="lb-nav" id="lb-next">&#8250;</button>
</div>

<footer>
    <div class="container">
        <p>© 2026 Маргарита Антонова &nbsp;·&nbsp;
           <a href="https://max.ru/join/DQJsHDoQ0rxT-gDAfz7WkXgN426ROLxWf-kTq69cXN8" target="_blank" rel="noopener">Max.ru</a>
           &nbsp;·&nbsp;
           <a href="mailto:margaritka15789@gmail.com">margaritka15789@gmail.com</a>
        </p>
    </div>
</footer>

<script>
const PORTFOLIO=[
'@)

# ═══════════════ ЧАСТЬ 2: ДАННЫЕ ПОРТФОЛИО ═══════════════
$first = $true
foreach ($cat in $catDefs) {
    $catPath = Join-Path $portfolioPath $cat.key
    if (-not (Test-Path $catPath)) { Write-Host "  Папка не найдена: $($cat.key)"; continue }
    $exts  = @(".jpg",".jpeg",".png",".webp",".mp4",".webm",".mov")
    $files = Get-ChildItem $catPath -File | Where-Object { $_.Extension.ToLower() -in $exts }
    foreach ($f in $files) {
        Write-Host "  → $($f.Name) ($([math]::Round($f.Length/1KB,0)) KB)"
        $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
        $b64   = [System.Convert]::ToBase64String($bytes)
        $mime  = Get-Mime $f.Extension
        if (-not $first) { $sw.Write(',') }
        $sw.Write("{cat:`"$($cat.key)`",type:`"$($cat.type)`",src:`"data:$mime;base64,$b64`"}")
        $first = $false
        $b64 = $null; $bytes = $null
        [GC]::Collect()
    }
}

# ═══════════════ ЧАСТЬ 3: JS + ЗАКРЫТИЕ ═══════════════
$sw.Write(@'
];

/* ── STARS ── */
(function(){
    const cvs=document.getElementById('stars'),ctx=cvs.getContext('2d');
    let tiny=[],medium=[],bright=[],shooting=[],W=0,H=0,lastTs=0,nextShoot=0;
    const COLS=[[220,220,255],[255,255,255],[200,215,255],[255,245,215],[215,205,255],[180,210,255]];
    function rndCol(){return COLS[Math.floor(Math.random()*COLS.length)];}
    function resize(){W=cvs.width=window.innerWidth;H=cvs.height=window.innerHeight;mk();}
    function mk(){
        tiny=[];medium=[];bright=[];
        for(let i=0,n=Math.round(W*H/1600);i<n;i++) tiny.push({x:Math.random()*W,y:Math.random()*H,r:Math.random()*0.55+0.15,ph:Math.random()*Math.PI*2,sp:Math.random()*0.5+0.15,c:rndCol()});
        for(let i=0,n=Math.round(W*H/7000);i<n;i++) medium.push({x:Math.random()*W,y:Math.random()*H,r:Math.random()*1.1+0.6,ph:Math.random()*Math.PI*2,sp:Math.random()*0.6+0.2,c:rndCol()});
        for(let i=0,n=Math.max(8,Math.round(W*H/30000));i<n;i++) bright.push({x:Math.random()*W,y:Math.random()*H,r:Math.random()*1.6+1.2,gr:Math.random()*10+7,ph:Math.random()*Math.PI*2,sp:Math.random()*0.7+0.25,c:rndCol()});
    }
    function draw(ts){
        const dt=Math.min((ts-lastTs)*0.001,0.1);lastTs=ts;const t=ts*0.001;
        ctx.clearRect(0,0,W,H);
        for(const s of tiny){const a=(Math.sin(t*s.sp+s.ph)*0.3+0.7)*0.55;ctx.beginPath();ctx.arc(s.x,s.y,s.r,0,Math.PI*2);ctx.fillStyle=`rgba(${s.c[0]},${s.c[1]},${s.c[2]},${a})`;ctx.fill();}
        for(const s of medium){const a=(Math.sin(t*s.sp+s.ph)*0.35+0.65)*0.85;ctx.beginPath();ctx.arc(s.x,s.y,s.r,0,Math.PI*2);ctx.fillStyle=`rgba(${s.c[0]},${s.c[1]},${s.c[2]},${a})`;ctx.fill();}
        for(const s of bright){
            const a=Math.sin(t*s.sp+s.ph)*0.3+0.7;
            const g=ctx.createRadialGradient(s.x,s.y,0,s.x,s.y,s.gr);
            g.addColorStop(0,`rgba(${s.c[0]},${s.c[1]},${s.c[2]},${(a*0.55).toFixed(3)})`);
            g.addColorStop(1,`rgba(${s.c[0]},${s.c[1]},${s.c[2]},0)`);
            ctx.beginPath();ctx.arc(s.x,s.y,s.gr,0,Math.PI*2);ctx.fillStyle=g;ctx.fill();
            ctx.beginPath();ctx.arc(s.x,s.y,s.r,0,Math.PI*2);ctx.fillStyle=`rgba(${s.c[0]},${s.c[1]},${s.c[2]},${a.toFixed(3)})`;ctx.fill();
        }
        if(ts>nextShoot&&shooting.length<2){shooting.push({x:Math.random()*W*0.75,y:Math.random()*H*0.45,vx:Math.random()*220+160,vy:Math.random()*110+55,life:1,len:Math.random()*130+60});nextShoot=ts+Math.random()*9000+4000;}
        for(let i=shooting.length-1;i>=0;i--){
            const s=shooting[i];s.x+=s.vx*dt;s.y+=s.vy*dt;s.life-=dt*1.6;
            if(s.life<=0){shooting.splice(i,1);continue;}
            const ang=Math.atan2(s.vy,s.vx),tx=s.x-Math.cos(ang)*s.len,ty=s.y-Math.sin(ang)*s.len;
            const sg=ctx.createLinearGradient(tx,ty,s.x,s.y);
            sg.addColorStop(0,'rgba(255,255,255,0)');sg.addColorStop(0.55,`rgba(200,220,255,${(s.life*0.45).toFixed(3)})`);sg.addColorStop(1,`rgba(255,255,255,${s.life.toFixed(3)})`);
            ctx.beginPath();ctx.moveTo(tx,ty);ctx.lineTo(s.x,s.y);ctx.strokeStyle=sg;ctx.lineWidth=1.5;ctx.stroke();
        }
        requestAnimationFrame(draw);
    }
    window.addEventListener('resize',resize);resize();
    nextShoot=performance.now()+2500;requestAnimationFrame(draw);
})();

/* ── ACCORDION ── */
function toggleCat(card){card.classList.toggle('open');}

/* ── PORTFOLIO ── */
let currentItems=PORTFOLIO,current=-1;

function renderGrid(filter){
    currentItems=filter==='all'?PORTFOLIO:PORTFOLIO.filter(i=>i.cat===filter);
    const grid=document.getElementById('grid');
    grid.innerHTML='';
    if(!currentItems.length){
        grid.innerHTML='<div class="p-empty">В этой категории пока нет работ</div>';return;
    }
    currentItems.forEach((item,i)=>{
        const el=document.createElement('div');
        el.className='p-item'+(item.type==='video'?' p-video':'');
        if(item.type==='video'){
            el.innerHTML=`<video src="${item.src}" muted loop playsinline preload="metadata"></video><div class="p-overlay"><svg viewBox="0 0 24 24" width="48" height="48" fill="white"><path d="M8 5v14l11-7z"/></svg></div>`;
            const vid=el.querySelector('video');
            el.addEventListener('mouseenter',()=>vid.play());
            el.addEventListener('mouseleave',()=>{vid.pause();vid.currentTime=0;});
        } else {
            el.innerHTML=`<img src="${item.src}" loading="lazy" alt=""><div class="p-overlay"><svg viewBox="0 0 24 24" width="36" height="36" fill="white"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5C21.27 7.61 17 4.5 12 4.5zm0 12.5c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg></div>`;
        }
        el.addEventListener('click',()=>openLB(i));
        grid.appendChild(el);
    });
}

document.querySelectorAll('.f-btn').forEach(btn=>{
    btn.addEventListener('click',()=>{
        document.querySelectorAll('.f-btn').forEach(b=>b.classList.remove('active'));
        btn.classList.add('active');
        renderGrid(btn.dataset.filter);
    });
});

/* ── LIGHTBOX ── */
const lb=document.getElementById('lightbox');
const lbImg=document.getElementById('lb-img');
const lbVideo=document.getElementById('lb-video');

function openLB(i){current=i;showLBItem(currentItems[i]);lb.classList.add('open');document.body.style.overflow='hidden';}

function showLBItem(item){
    if(item.type==='video'){
        lbImg.style.display='none';lbVideo.style.display='block';
        lbVideo.src=item.src;lbVideo.play().catch(()=>{});
    } else {
        lbVideo.pause();lbVideo.src='';lbVideo.style.display='none';
        lbImg.style.display='block';lbImg.src=item.src;
    }
}

function closeLB(){lb.classList.remove('open');lbVideo.pause();lbVideo.src='';document.body.style.overflow='';current=-1;}
function prevItem(){if(currentItems.length<2)return;current=(current-1+currentItems.length)%currentItems.length;showLBItem(currentItems[current]);}
function nextItem(){if(currentItems.length<2)return;current=(current+1)%currentItems.length;showLBItem(currentItems[current]);}

document.getElementById('lb-close').addEventListener('click',closeLB);
document.getElementById('lb-prev').addEventListener('click',prevItem);
document.getElementById('lb-next').addEventListener('click',nextItem);
lb.addEventListener('click',e=>{if(e.target===lb)closeLB();});
document.addEventListener('keydown',e=>{
    if(!lb.classList.contains('open'))return;
    if(e.key==='Escape')closeLB();
    if(e.key==='ArrowLeft')prevItem();
    if(e.key==='ArrowRight')nextItem();
});

renderGrid('all');
</script>
</body>
</html>
'@)

$sw.Flush()
$sw.Close()
Write-Host ""
Write-Host "Готово! vizitka.html создан."
$size = [math]::Round((Get-Item $outputPath).Length/1MB,1)
Write-Host "Размер файла: $size МБ"
