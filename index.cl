<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Tómbola 1-20</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            background-color: #f0f2f5;
            color: #333;
        }

        h1, h2 {
            color: #2c3e50;
            text-align: center;
        }

        #tombola {
            position: relative;
            width: 300px;
            height: 300px;
            margin-bottom: 20px;
            overflow: hidden;
        }

        .gif-fondo {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .bola {
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: white;
            border-radius: 50%;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            font-weight: bold;
            font-size: 2em;
            color: #333;
            animation: bounceIn 0.8s cubic-bezier(0.68, -0.55, 0.27, 1.55);
            transition: all 0.5s ease-in-out;
        }

        .bola.grande {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 80px;
            height: 80px;
            z-index: 10;
        }

        .bola.aparece {
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes bounceIn {
            0% { transform: translate(-50%, -50%) scale(0.3); opacity: 0; }
            50% { transform: translate(-50%, -50%) scale(1.1); opacity: 1; }
            100% { transform: translate(-50%, -50%) scale(1); }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        #sortear {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 12px 24px;
            font-size: 1.2em;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.1s;
        }

        #sortear:hover {
            background-color: #2980b9;
        }

        #sortear:active {
            transform: scale(0.98);
        }

        #sortear:disabled {
            background-color: #bdc3c7;
            cursor: not-allowed;
        }

        hr {
            width: 80%;
            border: 0;
            border-top: 1px solid #ccc;
            margin: 20px 0;
        }

        #bolas-sorteadas {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 10px;
            margin-top: 10px;
            max-width: 90%;
        }

        #bolas-sorteadas .bola {
            width: 45px;
            height: 45px;
            font-size: 1.2em;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .grid-numeros {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 10px;
            margin-top: 20px;
            text-align: center;
        }

        .grid-numeros span {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 40px;
            height: 40px;
            background-color: #ddd;
            border-radius: 50%;
            font-size: 1.2em;
            font-weight: bold;
            color: #333;
            transition: background-color 0.3s, color 0.3s;
        }

        .grid-numeros .sorteado {
            background-color: #4CAF50;
            color: white;
            box-shadow: 0 0 5px #4CAF50;
        }
    </style>
</head>
<body>
    <h1>Tómbola 1-20</h1>
    <div id="tombola">
        <img src="https://i.ibb.co/6P0D6kP/tombola-bg.gif" alt="Tómbola animada" class="gif-fondo">
        <div id="bola-seleccionada" class="bola grande" style="display:none;"></div>
    </div>
    <button id="sortear">🎯 ¡SORTEAR!</button>

    <hr>

    <h2>Números sorteados:</h2>
    <div id="bolas-sorteadas"></div>
    
    <hr>

    <h2>Lista de Comprobación:</h2>
    <div id="lista-comprobacion" class="grid-numeros">
        </div>

    <script>
        let disponibles = Array.from({ length: 20 }, (_, i) => i + 1);
        const bolaSeleccionada = document.getElementById("bola-seleccionada");
        const contenedorSorteadas = document.getElementById("bolas-sorteadas");
        const listaComprobacion = document.getElementById("lista-comprobacion");
        const botonSortear = document.getElementById("sortear");

        // Generar la lista de comprobación dinámicamente
        for (let i = 1; i <= 20; i++) {
            const numeroSpan = document.createElement("span");
            numeroSpan.id = `check-${i}`;
            numeroSpan.textContent = i;
            listaComprobacion.appendChild(numeroSpan);
        }

        function sortearNumero() {
            if (!disponibles.length) {
                bolaSeleccionada.textContent = "¡Fin!";
                bolaSeleccionada.style.display = "flex";
                botonSortear.disabled = true;
                return;
            }

            const index = Math.floor(Math.random() * disponibles.length);
            const numero = disponibles.splice(index, 1)[0];

            bolaSeleccionada.textContent = numero;
            bolaSeleccionada.style.display = "flex";

            setTimeout(() => {
                bolaSeleccionada.style.display = "none";

                const bolaFinal = document.createElement("div");
                bolaFinal.className = "bola";
                bolaFinal.textContent = numero;
                bolaFinal.classList.add('aparece');
                contenedorSorteadas.appendChild(bolaFinal);
                
                // Marcar el número en la lista de comprobación
                document.getElementById(`check-${numero}`).classList.add('sorteado');
            }, 1500);
        }

        document.getElementById("sortear").addEventListener("click", sortearNumero);
    </script>
</body>
</html>
