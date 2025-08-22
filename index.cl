Aquí tienes una **tómbola virtual** que genera números aleatorios del **1 al 20** y muestra una **lista de comprobación** en la parte inferior.
Cada número sorteado se marcará automáticamente en la lista para que sea fácil llevar el control.

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tómbola Virtual</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f4f6f9;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      margin: 0;
    }

    h1 {
      color: #222;
      margin-bottom: 20px;
    }

    #numero-sorteado {
      font-size: 5rem;
      font-weight: bold;
      margin: 20px 0;
      color: #0077ff;
    }

    button {
      background-color: #0077ff;
      color: white;
      border: none;
      padding: 15px 30px;
      font-size: 1.2rem;
      border-radius: 8px;
      cursor: pointer;
      transition: background 0.3s;
      margin-bottom: 30px;
    }

    button:hover {
      background-color: #005cd6;
    }

    #lista-numeros {
      display: grid;
      grid-template-columns: repeat(10, 1fr);
      gap: 10px;
      max-width: 500px;
    }

    .numero {
      width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      background-color: #e0e0e0;
      color: #666;
      font-weight: bold;
      transition: all 0.3s ease;
    }

    .marcado {
      background-color: #0077ff;
      color: white;
      transform: scale(1.1);
    }
  </style>
</head>
<body>
  <h1>Tómbola Virtual</h1>
  <div id="numero-sorteado">--</div>
  <button id="sortear">🎲 Sortear número</button>

  <div id="lista-numeros"></div>

  <script>
    const boton = document.getElementById("sortear");
    const numeroSorteado = document.getElementById("numero-sorteado");
    const listaNumeros = document.getElementById("lista-numeros");

    let numerosDisponibles = Array.from({ length: 20 }, (_, i) => i + 1);

    // Crear la lista de números al inicio
    numerosDisponibles.forEach(num => {
      const div = document.createElement("div");
      div.classList.add("numero");
      div.id = `num-${num}`;
      div.textContent = num;
      listaNumeros.appendChild(div);
    });

    boton.addEventListener("click", () => {
      if (numerosDisponibles.length === 0) {
        alert("¡Ya no hay más números disponibles!");
        return;
      }

      // Obtener índice aleatorio y número correspondiente
      const indice = Math.floor(Math.random() * numerosDisponibles.length);
      const numero = numerosDisponibles.splice(indice, 1)[0];

      // Mostrar el número sorteado
      numeroSorteado.textContent = numero;

      // Marcarlo en la lista de comprobación
      const elemento = document.getElementById(`num-${numero}`);
      elemento.classList.add("marcado");
    });
  </script>
</body>
</html>
```

### **Características:**

* 🎲 **Genera números aleatorios del 1 al 20**.
* ✅ Los números **no se repiten**.
* 🟢 Cada número sorteado se **marca visualmente** en la lista.
* 📋 Lista organizada en **10 columnas**, clara y fácil de leer.

Si quieres, puedo hacer que la tómbola tenga **una animación giratoria** antes de mostrar el número sorteado, para darle un efecto más vistoso.
¿Te interesa que le agregue eso?
