<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1" />
<title>Sopa de Letras 7×7 — Jungle</title>
<style>
  :root{
    --size: 7;                 /* tamaño de la grilla */
    --cell: clamp(38px, 8vw, 64px);
    --accent: #0ea5e9;         /* celeste lindo */
    --found: #16a34a;          /* verde encontrado */
    --grid-gap: 6px;
    --bg: #0b1020;
    --panel: #111832;
    --panel-2:#0f1530;
    --text:#e7eefb;
    --muted:#9fb1d3;
  }
  *{box-sizing:border-box}
  html,body{height:100%}
  body{
    margin:0;
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, "Apple Color Emoji","Segoe UI Emoji";
    background: radial-gradient(1200px 1200px at 10% -10%, #172046 0%, #0b1020 60%);
    color: var(--text);
    -webkit-user-select:none; user-select:none;
    touch-action: none;
  }
  header{
    padding: 16px 16px 0 16px;
    display:flex; gap:12px; align-items:center; flex-wrap:wrap;
  }
  header h1{font-size: clamp(18px,3.4vw,24px); margin:0 8px 0 0; letter-spacing:.5px}
  .pill{font-size:12px; color:#cfe5ff; opacity:.8; border:1px solid #244; padding:4px 8px; border-radius:999px}
  main{
    padding: 16px;
    display:grid; gap:16px;
    grid-template-columns: 1fr;
  }
  @media (min-width: 880px){
    main{grid-template-columns: 1fr minmax(280px, 360px);}
  }
  /* Grid */
  .board{
    background: linear-gradient(180deg, var(--panel), var(--panel-2));
    border:1px solid #223153;
    border-radius: 18px;
    padding: 14px;
    box-shadow: 0 8px 28px rgba(0,0,0,.35), inset 0 1px 0 rgba(255,255,255,.06);
  }
  .grid{
    display:grid;
    grid-template-columns: repeat(var(--size), var(--cell));
    grid-template-rows: repeat(var(--size), var(--cell));
    gap: var(--grid-gap);
    justify-content:center;
    touch-action: none;
  }
  .cell{
    width: var(--cell); height: var(--cell);
    border-radius: 10px;
    display:grid; place-items:center;
    font-weight: 800; letter-spacing:.5px;
    background: #0e1634;
    border: 1px solid #1f2b57;
    box-shadow: inset 0 -6px 10px rgba(0,0,0,.3);
    transition: transform .06s ease, background .08s ease, color .08s ease, box-shadow .08s ease;
  }
  .cell span{pointer-events:none}
  .cell.highlight{ outline: 2px solid var(--accent); background:#0b2242; color:#def7ff }
  .cell.found{ background:#0d2b1a; color:#d8ffe8; border-color:#1f6a3a; box-shadow: inset 0 -6px 10px rgba(0,0,0,.25), 0 0 0 2px #1f6a3a55}
  .cell.locked{ pointer-events:none }

  /* Lateral */
  .side{
    display:flex; flex-direction:column; gap:12px;
  }
  .card{
    background: linear-gradient(180deg, #0f1531, #0c122c);
    border:1px solid #223153; border-radius: 16px; padding:12px;
  }
  .card h2{font-size:14px; margin:4px 0 10px; color:#cde1ff; opacity:.9; letter-spacing:.4px}
  .list{
    display:flex; flex-wrap:wrap; gap:8px;
  }
  .tag{
    font-size:14px; padding:6px 10px; border-radius:999px;
    background:#0b1b38; border:1px solid #1b2a52; color:#cfe5ff;
  }
  .tag.found{ background:#0b2c1b; border-color:#1f6a3a; color:#bff5d3; text-decoration: line-through; text-decoration-thickness: 2px; }
  textarea{
    width:100%; min-height:120px; resize:vertical;
    background:#0a1330; color:#e7eefb; border:1px solid #223153; border-radius:10px; padding:10px; font-size:14px; line-height:1.4;
  }
  .row{display:flex; gap:8px; flex-wrap:wrap}
  button{
    appearance:none; border:none; cursor:pointer;
    padding:10px 14px; border-radius:12px; font-weight:700;
    background:#0a2a4d; color:#cfe5ff; border:1px solid #1e3a66;
    box-shadow: 0 4px 10px rgba(0,0,0,.25);
  }
  button.primary{ background: #0d4d7c; border-color:#166aa3;}
  .muted{color:var(--muted); font-size:13px}
  footer{ padding: 4px 16px 16px; color:#91a7d7; font-size:12px; opacity:.9}
</style>
</head>
<body>
  <header>
    <h1>Sopa de Letras 7×7</h1>
    <span class="pill">Mobile-first</span>
    <span class="pill">Drag & Touch</span>
    <span class="pill">8 direcciones</span>
  </header>

  <main>
    <section class="board">
      <div id="grid" class="grid" aria-label="Tablero de sopa de letras"></div>
      <footer class="muted">Tip: arrastra en línea recta; se acepta la palabra normal o al revés.</footer>
    </section>

    <aside class="side">
      <div class="card">
        <h2>Palabras</h2>
        <div id="wordList" class="list" role="list"></div>
      </div>

      <div class="card">
        <h2>Editar palabras (una por línea)</h2>
        <textarea id="wordsInput">JUNGLE
EVENTO
EQUIPO
JUEGO
RAPIDO
CHILE
DISEÑO</textarea>
        <div class="row" style="margin-top:8px">
          <button id="apply" class="primary">Aplicar & Barajar</button>
          <button id="shuffle">Barajar letras</button>
          <button id="reset">Reiniciar</button>
        </div>
        <p class="muted" style="margin:8px 0 0">
          Se normalizan acentos y espacios. Tamaño fijo: 7×7.
        </p>
      </div>
    </aside>
  </main>

<script>
(() => {
  // -------- Utilidades --------
  const SIZE = 7;
  const gridEl = document.getElementById('grid');
  const wordListEl = document.getElementById('wordList');
  const inputEl = document.getElementById('wordsInput');
  const byId = (id)=>document.getElementById(id);

  const DIRS = [
    [ 0,  1],  // derecha
    [ 0, -1],  // izquierda
    [ 1,  0],  // abajo
    [-1,  0],  // arriba
    [ 1,  1],  // diag ↘
    [-1, -1],  // diag ↖
    [ 1, -1],  // diag ↙
    [-1,  1],  // diag ↗
  ];

  const normalize = (s)=>
    s.toUpperCase()
     .normalize('NFD').replace(/[\u0300-\u036f]/g,'') // quita acentos
     .replace(/[^A-ZÑ]/g,'') // sólo letras (permite Ñ)
     .trim();

  const rand = (n)=>Math.floor(Math.random()*n);
  const letters = "ABCDEFGHIIJKLMNÑOPQRSTUVWXYZ"; // doble I para un poco más vocales
  const randomLetter = ()=> letters[rand(letters.length)];

  // -------- Estado --------
  let cells = [];          // DOM de celdas
  let grid = [];           // matriz de letras
  let placed = [];         // {word, cells:[{r,c}], found:boolean}
  let tags = new Map();    // palabra -> DOM tag

  // -------- Construcción DOM --------
  function buildGrid(){
    gridEl.style.setProperty('--size', SIZE);
    gridEl.innerHTML = '';
    cells = [];
    grid = Array.from({length: SIZE}, ()=> Array(SIZE).fill(''));
    for(let r=0;r<SIZE;r++){
      for(let c=0;c<SIZE;c++){
        const div = document.createElement('div');
        div.className = 'cell';
        div.dataset.r = r; div.dataset.c = c;
        const span = document.createElement('span');
        span.textContent = '·';
        div.appendChild(span);
        gridEl.appendChild(div);
        cells.push(div);
      }
    }
  }

  function renderGrid(){
    for(let r=0;r<SIZE;r++){
      for(let c=0;c<SIZE;c++){
        const idx = r*SIZE + c;
        const el = cells[idx];
        el.querySelector('span').textContent = grid[r][c] || '·';
      }
    }
  }

  function clearHighlights(){
    cells.forEach(el=>el.classList.remove('highlight'));
  }

  function markFound(wordObj){
    wordObj.found = true;
    for(const {r,c} of wordObj.cells){
      const idx = r*SIZE + c;
      cells[idx].classList.add('found','locked');
    }
    const tag = tags.get(wordObj.word);
    if(tag){ tag.classList.add('found'); }
  }

  // -------- Colocación de palabras --------
  function canPlace(word, r, c, dr, dc){
    for(let i=0;i<word.length;i++){
      const rr = r + dr*i, cc = c + dc*i;
      if(rr<0 || rr>=SIZE || cc<0 || cc>=SIZE) return false;
      const current = grid[rr][cc];
      if(current && current !== word[i]) return false;
    }
    return true;
  }

  function placeAt(word, r, c, dr, dc){
    const coords = [];
    for(let i=0;i<word.length;i++){
      const rr = r + dr*i, cc = c + dc*i;
      grid[rr][cc] = word[i];
      coords.push({r: rr, c: cc});
    }
    placed.push({ word, cells: coords, found: false });
  }

  function tryPlaceWord(word){
    // intentamos direcciones y posiciones aleatorias varias veces
    const attempts = 120;
    for(let k=0;k<attempts;k++){
      const [dr,dc] = DIRS[rand(DIRS.length)];
      const maxR = dr>=0 ? SIZE - word.length : SIZE - 1;
      const maxC = dc>=0 ? SIZE - word.length : SIZE - 1;
      const minR = dr<=0 ? word.length-1 : 0;
      const minC = dc<=0 ? word.length-1 : 0;

      // rangos seguros
      const r = dr>=0 ? rand(maxR - 0 + 1) + 0
                      : rand(maxR - minR + 1) + minR;
      const c = dc>=0 ? rand(maxC - 0 + 1) + 0
                      : rand(maxC - minC + 1) + minC;

      const sr = dr<0 ? r : r; // ya contemplado en canPlace
      const sc = dc<0 ? c : c;

      if(canPlace(word, sr, sc, dr, dc)){
        placeAt(word, sr, sc, dr, dc);
        return true;
      }
    }
    return false;
  }

  function fillRandom(){
    for(let r=0;r<SIZE;r++){
      for(let c=0;c<SIZE;c++){
        if(!grid[r][c]) grid[r][c] = randomLetter();
      }
    }
  }

  // -------- Lista de palabras --------
  function renderWords(words){
    wordListEl.innerHTML = '';
    tags.clear();
    for(const w of words){
      const tag = document.createElement('div');
      tag.className = 'tag';
      tag.textContent = w;
      wordListEl.appendChild(tag);
      tags.set(w, tag);
    }
  }

  // -------- Generación completa --------
  function generate(wordsRaw){
    placed = [];
    buildGrid();

    const words = wordsRaw
      .split('\n')
      .map(normalize)
      .filter(Boolean)
      .filter(w => w.length>=2 && w.length<=SIZE); // caben en 7×7

    // Ordena de largo a corto para facilitar colocación
    words.sort((a,b)=> b.length - a.length);

    renderWords(words);

    // Coloca palabras
    for(const w of words){
      const ok = tryPlaceWord(w);
      if(!ok){
        console.warn('No se pudo ubicar:', w);
      }
    }
    fillRandom();
    renderGrid();
    attachInteraction();
  }

  // -------- Interacción (drag / touch) --------
  let selecting = false;
  let startCell = null;
  let currentPath = [];

  function getCellFromEvent(e){
    const target = e.target.closest('.cell');
    if(!target) return null;
    const r = +target.dataset.r, c = +target.dataset.c;
    return {el: target, r, c};
  }

  function direction(from, to){
    const dr = Math.sign(to.r - from.r);
    const dc = Math.sign(to.c - from.c);
    // debe ser línea recta: misma fila/col/diagonal
    const vr = Math.abs(to.r - from.r);
    const vc = Math.abs(to.c - from.c);
    if(from.r===to.r || from.c===to.c || vr===vc){
      return [dr, dc];
    }
    return null;
  }

  function pathBetween(a,b){
    const dir = direction(a,b);
    if(!dir) return null;
    const [dr,dc] = dir;
    const steps = Math.max(Math.abs(b.r - a.r), Math.abs(b.c - a.c));
    const out = [];
    for(let i=0;i<=steps;i++){
      const rr = a.r + dr*i, cc = a.c + dc*i;
      out.push({r:rr,c:cc});
    }
    return out;
  }

  function selectionString(path){
    return path.map(({r,c})=>grid[r][c]).join('');
  }

  function isMatch(str){
    for(const obj of placed){
      if(obj.found) continue;
      if(str === obj.word || str.split('').reverse().join('') === obj.word){
        return obj;
      }
    }
    return null;
  }

  function highlightPath(path){
    clearHighlights();
    if(!path) return;
    for(const {r,c} of path){
      const idx = r*SIZE + c;
      cells[idx].classList.add('highlight');
    }
  }

  function lockPath(path){
    for(const {r,c} of path){
      const idx = r*SIZE + c;
      cells[idx].classList.remove('highlight');
      cells[idx].classList.add('found','locked');
    }
  }

  function attachInteraction(){
    // Limpia handlers previos
    gridEl.onpointerdown = gridEl.onpointermove = gridEl.onpointerup = null;
    gridEl.addEventListener('pointerdown', onDown, {passive:false});
    gridEl.addEventListener('pointermove', onMove, {passive:false});
    gridEl.addEventListener('pointerup',   onUp,   {passive:false});
    gridEl.addEventListener('pointercancel', onUp, {passive:false});
    gridEl.addEventListener('pointerleave',  onUp, {passive:false});
  }

  function onDown(e){
    e.preventDefault();
    const cell = getCellFromEvent(e);
    if(!cell || cell.el.classList.contains('locked')) return;
    selecting = true;
    startCell = cell;
    currentPath = [cell];
    highlightPath(currentPath);
  }

  function onMove(e){
    if(!selecting) return;
    e.preventDefault();
    const cell = getCellFromEvent(e);
    if(!cell) return;
    const path = pathBetween(startCell, cell);
    currentPath = path || [startCell];
    highlightPath(currentPath);
  }

  function onUp(e){
    if(!selecting) return;
    e.preventDefault();
    selecting = false;

    const str = selectionString(currentPath);
    const match = isMatch(str);
    if(match){
      lockPath(currentPath);
      match.found = true;
      const tag = tags.get(match.word);
      if(tag) tag.classList.add('found');
      // ¿Ganó?
      const allFound = placed.filter(p=>tags.has(p.word)).every(p=>p.found);
      if(allFound){
        celebrate();
      }
    }else{
      clearHighlights();
    }
    startCell = null;
    currentPath = [];
  }

  // -------- Pequeño "confeti" minimalista (notas) --------
  function celebrate(){
    const n = 24;
    for(let i=0;i<n;i++){
      const b = document.createElement('div');
      b.textContent = ['♪','♫','♬','♩'][i%4];
      Object.assign(b.style,{
        position:'fixed',
        left: (Math.random()*100)+'vw',
        top: '-10vh',
        fontSize: (18+Math.random()*18)+'px',
        pointerEvents:'none',
        zIndex: 9999,
        transition:'transform 1.2s ease, opacity 1.2s ease',
        opacity:'1'
      });
      document.body.appendChild(b);
      requestAnimationFrame(()=>{
        b.style.transform = `translateY(${110+Math.random()*20}vh) rotate(${(Math.random()*720-360)}deg)`;
        b.style.opacity = '0';
      });
      setTimeout(()=>b.remove(), 1400);
    }
  }

  // -------- Botones --------
  byId('apply').addEventListener('click', ()=>{
    generate(inputEl.value);
  });
  byId('shuffle').addEventListener('click', ()=>{
    // Sólo re-rellena letras aleatorias donde no hay palabras (no borra palabras)
    for(const obj of placed){
      if(!obj) continue;
      for(const {r,c} of obj.cells){
        // marca temporal para no sobrescribir
        grid[r][c] = grid[r][c] || '?';
      }
    }
    for(let r=0;r<SIZE;r++){
      for(let c=0;c<SIZE;c++){
        const isWordCell = placed.some(p => p.cells.some(cc => cc.r===r && cc.c===c));
        if(!isWordCell) grid[r][c] = randomLetter();
      }
    }
    renderGrid();
  });
  byId('reset').addEventListener('click', ()=>{
    generate(inputEl.value);
  });

  // -------- Init --------
  generate(inputEl.value);
})();
</script>
</body>
</html>

