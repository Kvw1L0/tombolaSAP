<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Tómbola 1–20</title>
  <style>
    /* ====== Estilos básicos y robustos ====== */
    :root{
      --bg:#0e1220; 
      --card:#171b2e; 
      --ink:#eef1ff; 
      --muted:#8b90a8;
      --accent:#7ea8ff;
      --chipOff:#141a33;
      --chipOn1:#aaffbf; 
      --chipOn2:#66ffa6;
    }
    *{box-sizing:border-box}
    html,body{height:100%}
    body{
      margin:0; display:grid; place-items:center; min-height:100vh;
      background:#0b0f1e;
      color:var(--ink); font-family:system-ui, -apple-system, Segoe UI, Roboto, Inter, Arial, sans-serif;
    }
    .wrap{ width:min(720px,94vw); padding:20px; }

    .card{
      background:#151a2c; border:1px solid #2c3561; border-radius:18px; 
      padding:20px; box-shadow:0 10px 30px rgba(0,0,0,.5);
    }
    h1{margin:0 0 6px; font-size:clamp(18px,2.5vw,22px)}
    .sub{margin:0 0 14px; font-size:14px; color:var(--muted)}

    .screen{
      height:160px; display:grid; place-items:center; 
      background:#0f1430; border:1px solid #2a3358; border-radius:14px; 
      margin:10px 0 16px; overflow:hidden; position:relative;
    }
    .num{
      font-weight:800; line-height:1; letter-spacing:1px;
      font-size: clamp(64px, 12vw, 120px);
      text-shadow: 0 8px 24px rgba(0,0,0,.6);
      transform: scale(0.9);
      transition: transform .18s ease;
    }
    .num.bump{ transform: scale(1.06); }

    .controls{ display:flex; gap:12px; flex-wrap:wrap; }
    button{
      appearance:none; border:1px solid #31406e; background:#1a2142; color:var(--ink);
      padding:12px 16px; border-radius:12px; font-weight:700; cursor:pointer;
      transition: transform .06s ease, background .2s ease, border-color .2s ease, opacity .2s ease;
    }
    button:hover{ transform: translateY(-1px); background:#212a56; border-color:#43549e; }
    button:active{ transform: translateY(0); }
    button:disabled{ opacity:.55; cursor:not-allowed; }

    .grid{
      margin-top:14px; display:grid; grid-template-columns: repeat(10, 1fr);
      gap:8px;
    }
    .chip{
      border:1px solid #2a3358; padding:10px 0; text-align:center; border-radius:10px;
      font-weight:700; user-select:none; 
      color:#a6abc5; background:var(--chipOff);
      opacity:.5; transition: background .2s ease, color .2s ease, border-color .2s ease, transform .12s ease, opacity .2s ease;
    }
    .chip.hit{
      color:#04280f; 
      background: linear-gradient(180deg, var(--chipOn1), var(--chipOn2));
      border-color:#1e8b3e; opacity:1; transform: translateY(-2px);
      box-shadow: inset 0 6px 14px rgba(11,43,21,.8), 0 2px 10px rgba(11,43,21,.25);
    }

    .foot{
      margin-top:10px; font-size:12px; color:var(--muted);
      display:flex; justify-content:space-between; gap:8px; flex-wrap:wrap;
    }
    .pill{
      border:1px dashed #31406e; padding:6px 10px; border-radius:999px;
    }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="card">
      <h1>🎲 Tómbola 1–20</h1>
      <p class="sub">Saca números al azar sin repetir. Abajo se marcan automáticamente.</p>

      <div class="screen">
        <div id="current" class="num">—</div>
      </div>

      <div class="controls">
        <button id="drawBtn" type="button">Sacar número</button>
        <button id="resetBtn" type="button" title="Limpiar todo">Reiniciar</button>
      </div>

      <div id="grid" class="grid" aria-label="Números del 1 al 20"></div>

      <div class="foot">
        <div class="pill">Restantes: <strong id="leftCount">20</strong></div>
        <div class="pill">Sacados: <strong id="drawnCount">0</strong></div>
      </div>
    </div>
  </div>

  <script>
    (function(){
      // ====== Config ======
      const MIN = 1, MAX = 20;

      // ====== Estado ======
      let pool = [];
      let drawn = new Set();

      // ====== DOM ======
      const grid = document.getElementById('grid');
      const current = document.getElementById('current');
      const drawBtn = document.getElementById('drawBtn');
      const resetBtn = document.getElementById('resetBtn');
      const leftCount = document.getElementById('leftCount');
      const drawnCount = document.getElementById('drawnCount');

      // ====== Util ======
      function range(a,b){ const out=[]; for(let i=a;i<=b;i++) out.push(i); return out; }
      function animateNumber(){
        current.classList.remove('bump');
        // Forzar reflow para reiniciar animación
        void current.offsetWidth;
        current.classList.add('bump');
      }

      // ====== Grilla ======
      function buildGrid(){
        const frag = document.createDocumentFragment();
        range(MIN,MAX).forEach(n=>{
          const chip = document.createElement('div');
          chip.className = 'chip';
          chip.dataset.n = String(n);
          chip.textContent = n;
          frag.appendChild(chip);
        });
        grid.innerHTML = '';
        grid.appendChild(frag);
      }
      function markChip(n){
        const el = grid.querySelector('.chip[data-n="'+n+'"]');
        if(el) el.classList.add('hit');
      }
      function unmarkAll(){
        grid.querySelectorAll('.chip.hit').forEach(el => el.classList.remove('hit'));
      }

      // ====== Pool & Conteos ======
      function refillPool(){
        pool = range(MIN,MAX).filter(n => !drawn.has(n));
      }
      function setCounts(){
        leftCount.textContent = String(pool.length);
        drawnCount.textContent = String(drawn.size);
      }

      // ====== Acciones ======
      function draw(){
        if(pool.length === 0) return;
        const i = Math.floor(Math.random() * pool.length);
        const n = pool.splice(i,1)[0];
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
      function reset(){
        drawn.clear();
        refillPool();
        current.textContent = '—';
        unmarkAll();
        drawBtn.disabled = false;
        drawBtn.textContent = 'Sacar número';
        setCounts();
      }

      // ====== Init ======
      buildGrid();
      reset();

      // ====== Eventos ======
      drawBtn.addEventListener('click', draw);
      resetBtn.addEventListener('click', reset);
      document.addEventListener('keydown', (e)=>{
        if(e.key === 'Enter') draw();
        if(e.key.toLowerCase && e.key.toLowerCase() === 'r') reset();
      });
    })();
  </script>
</body>
</html>
