<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Tómbola 1–20</title>
  <style>
    :root{
      --bg:#0f1220; --card:#171a2b; --ink:#e8ecff;
      --accent:#7ea8ff; --muted:#61688a; --hit:#a3ffa3;
    }
    *{box-sizing:border-box}
    body{
      margin:0; min-height:100svh; display:grid; place-items:center;
      background: radial-gradient(1200px 800px at 70% -10%, #182040 0%, #0f1220 55%, #0b0e18 100%);
      color:var(--ink); font-family: system-ui, -apple-system, Segoe UI, Roboto, Inter, Arial, sans-serif;
    }
    .wrap{
      width:min(720px,92vw); padding:20px;
    }
    .card{
      background: color-mix(in oklab, var(--card), black 5%);
      border:1px solid color-mix(in oklab, var(--accent), black 70%);
      border-radius:18px; padding:20px; box-shadow: 0 10px 30px #0008;
    }
    h1{margin:0 0 8px; font-size:clamp(18px,2.4vw,22px); font-weight:700; letter-spacing:.3px}
    .sub{color:var(--muted); font-size:14px; margin-bottom:14px}

    .screen{
      display:grid; place-items:center; height:160px;
      background:linear-gradient(180deg, #12162a, #0f1427);
      border:1px solid #2a3358; border-radius:16px; margin:10px 0 16px;
      position:relative; overflow:hidden;
    }
    .num{
      font-weight:800; line-height:1; letter-spacing:1px;
      font-size: clamp(64px, 12vw, 120px);
      text-shadow: 0 8px 24px #000a;
      transform: scale(0.9);
      transition: transform .18s ease;
    }
    .num.bump{ transform: scale(1.05); }

    .controls{ display:flex; gap:12px; flex-wrap:wrap; }
    button{
      appearance:none; border:1px solid #2e3a66; background:#1a2142; color:var(--ink);
      padding:12px 16px; border-radius:12px; font-weight:700; cursor:pointer;
      transition: transform .06s ease, background .2s ease, border-color .2s ease, opacity .2s ease;
    }
    button:hover{ transform: translateY(-1px); background:#202a56; border-color:#44539a; }
    button:active{ transform: translateY(0); }
    button:disabled{ opacity:.5; cursor:not-allowed; }

    .grid{
      margin-top:14px; display:grid; grid-template-columns: repeat(10, 1fr);
      gap:8px;
    }
    .chip{
      border:1px solid #2a3358; padding:10px 0; text-align:center; border-radius:10px;
      font-weight:700; user-select:none; transition: background .2s ease, color .2s ease, border-color .2s ease, transform .12s ease;
      color: color-mix(in oklab, var(--ink), #000 40%);
      background: #131833;
      opacity:.5;
    }
    .chip.hit{
      color:#041607; background:linear-gradient(180deg, #aaffbf, #66ffa6);
      border-color:#1f8a3c; opacity:1; transform: translateY(-2px);
      box-shadow: 0 6px 16px #0b2b15cc inset, 0 2px 12px #0b2b1533;
    }

    .foot{
      margin-top:10px; font-size:12px; color:var(--muted);
      display:flex; justify-content:space-between; gap:8px; flex-wrap:wrap;
    }
    .pill{
      border:1px dashed #2e3a66; padding:6px 10px; border-radius:999px;
    }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="card">
      <h1>🎲 Tómbola 1–20</h1>
      <div class="sub">Saca números al azar sin repetir. Abajo se marcan automáticamente.</div>

      <div class="screen">
        <div id="current" class="num">—</div>
      </div>

      <div class="controls">
        <button id="drawBtn">Sacar número</button>
        <button id="resetBtn" title="Limpiar todo">Reiniciar</button>
      </div>

      <div id="grid" class="grid" aria-label="Números del 1 al 20"></div>

      <div class="foot">
        <div class="pill">Restantes: <strong id="leftCount">20</strong></div>
        <div class="pill">Sacados: <strong id="drawnCount">0</strong></div>
      </div>
    </div>
  </div>

  <script>
    // --- Estado ---
    const MIN = 1, MAX = 20;
    let pool = [];
    let drawn = new Set();

    // --- DOM ---
    const grid = document.getElementById('grid');
    const current = document.getElementById('current');
    const drawBtn = document.getElementById('drawBtn');
    const resetBtn = document.getElementById('resetBtn');
    const leftCount = document.getElementById('leftCount');
    const drawnCount = document.getElementById('drawnCount');

    // Construye la grilla 1..20
    function buildGrid(){
      grid.innerHTML = '';
      for(let n = MIN; n <= MAX; n++){
        const chip = document.createElement('div');
        chip.className = 'chip';
        chip.dataset.n = n;
        chip.textContent = n;
        grid.appendChild(chip);
      }
    }

    function setCounts(){
      leftCount.textContent = pool.length;
      drawnCount.textContent = drawn.size;
    }

    function refillPool(){
      pool = [];
      for(let n = MIN; n <= MAX; n++){
        if(!drawn.has(n)) pool.push(n);
      }
    }

    function markChip(n){
      const el = grid.querySelector(`.chip[data-n="${n}"]`);
      if(el){ el.classList.add('hit'); }
    }

    function unmarkAll(){
      grid.querySelectorAll('.chip').forEach(el => el.classList.remove('hit'));
    }

    function animateNumber(){
      current.classList.remove('bump');
      void current.offsetWidth; // reflow para reiniciar animación
      current.classList.add('bump');
    }

    function draw(){
      if(pool.length === 0) return;
      const i = Math.floor(Math.random() * pool.length);
      const n = pool.splice(i,1)[0]; // quita del pool
      drawn.add(n);
      current.textContent = n;
      animateNumber();
      markChip(n);
      setCounts();
      if(pool.length === 0){
        drawBtn.disabled = true;
        drawBtn.textContent = 'Sin números';
      }
    }

    function reset(all=true){
      drawn.clear();
      refillPool();
      current.textContent = '—';
      unmarkAll();
      drawBtn.disabled = false;
      drawBtn.textContent = 'Sacar número';
      setCounts();
    }

    // Inicializa
    buildGrid();
    reset();

    // Eventos
    drawBtn.addEventListener('click', draw);
    resetBtn.addEventListener('click', () => reset(true));

    // Accesos rápidos con teclado (Enter saca número)
    document.addEventListener('keydown', (e)=>{
      if(e.key === 'Enter'){ draw(); }
      if(e.key.toLowerCase() === 'r'){ reset(); }
    });
  </script>
</body>
</html>
