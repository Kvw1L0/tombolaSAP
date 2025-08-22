<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tómbola SAP Style</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --sap-blue-primary: #007cc0;
            --sap-blue-secondary: #005c8c;
            --sap-gray-light: #f5f5f5;
            --sap-gray-medium: #e0e0e0;
            --sap-gray-dark: #757575;
            --sap-text-color: #333;
            --sap-success-color: #2e8b57;
            --sap-shadow: 0 4px 8px rgba(0,0,0,0.1);
            --sap-shadow-hover: 0 6px 12px rgba(0,0,0,0.15);
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: var(--sap-gray-light);
            color: var(--sap-text-color);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .sap-container {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: var(--sap-shadow);
            width: 90%;
            max-width: 600px;
            overflow: hidden;
        }

        .sap-header {
            background-color: var(--sap-blue-primary);
            color: #fff;
            padding: 20px;
            text-align: center;
        }

        .sap-header h1 {
            margin: 0;
            font-size: 1.8rem;
            font-weight: 700;
        }

        .sap-main {
            padding: 20px;
        }

        .card {
            background-color: #fff;
            border: 1px solid var(--sap-gray-medium);
            border-radius: 8px;
            box-shadow: var(--sap-shadow);
            margin-bottom: 20px;
        }

        .card-header {
            background-color: var(--sap-gray-light);
            border-bottom: 1px solid var(--sap-gray-medium);
            padding: 10px 20px;
        }

        .card-header h2 {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 700;
        }

        .card-body {
            text-align: center;
            padding: 20px;
        }

        .numero-grande {
            font-size: 5rem;
            font-weight: 700;
            color: var(--sap-blue-primary);
            margin: 0;
            transition: all 0.5s ease-in-out;
        }

        .sap-button {
            display: block;
            width: 100%;
            padding: 15px;
            font-size: 1rem;
            font-weight: 700;
            color: #fff;
            background-color: var(--sap-blue-primary);
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.1s;
        }

        .sap-button:hover {
            background-color: var(--sap-blue-secondary);
        }

        .sap-button:active {
            transform: translateY(2px);
        }

        .divider {
            height: 1px;
            background-color: var(--sap-gray-medium);
            margin: 20px 0;
        }

        .numeros-container p {
            font-weight: 700;
            text-align: center;
            margin-bottom: 10px;
        }

        .grid-numeros {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 10px;
            text-align: center;
        }

        .numero-item {
            background-color: var(--sap-gray-light);
            border: 1px solid var(--sap-gray-medium);
            border-radius: 4px;
            padding: 10px;
            font-weight: 700;
            opacity: 0.5; /* Números atenuados por defecto */
            transition: opacity 0.3s, transform 0.3s, background-color 0.3s;
        }

        .numero-item.sorteado {
            background-color: var(--sap-success-color);
            color: #fff;
            opacity: 1; /* El número sorteado ya no está atenuado */
            font-size: 1.1rem;
            transform: scale(1.1);
            box-shadow: var(--sap-shadow);
        }
    </style>
</head>
<body>
    <div class="sap-container">
        <header class="sap-header">
            <h1>Tómbola SAP Style</h1>
        </header>
        <main class="sap-main">
            <div class="card">
                <div class="card-header">
                    <h2>Número Sorteado</h2>
                </div>
                <div class="card-body">
                    <p id="numero-sorteado" class="numero-grande">00</p>
                </div>
            </div>
            <button id="sortear-btn" class="sap-button">Sortear Número</button>
            <div class="divider"></div>
            <div class="numeros-container">
                <p>Historial de Números</p>
                <div id="lista-numeros" class="grid-numeros">
                    </div>
            </div>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const numeroSorteadoDisplay = document.getElementById('numero-sorteado');
            const sortearBtn = document.getElementById('sortear-btn');
            const listaNumerosContainer = document.getElementById('lista-numeros');

            // Inicializar los números disponibles del 1 al 20
            let numerosDisponibles = Array.from({ length: 20 }, (_, i) => i + 1);
            
            // Función para generar los elementos de los números en el HTML
            const generarListaNumeros = () => {
                for (let i = 1; i <= 20; i++) {
                    const numeroItem = document.createElement('div');
                    numeroItem.classList.add('numero-item');
                    numeroItem.textContent = i;
                    numeroItem.setAttribute('data-numero', i);
                    listaNumerosContainer.appendChild(numeroItem);
                }
            };

            // Función principal para sortear un número
            const sortearNumero = () => {
                // Verificar si aún quedan números para sortear
                if (numerosDisponibles.length === 0) {
                    alert('¡Todos los números han sido sorteados!');
                    sortearBtn.disabled = true;
                    return;
                }

                // Seleccionar un índice aleatorio
                const indiceAleatorio = Math.floor(Math.random() * numerosDisponibles.length);
                // Obtener el número sorteado
                const numeroSorteado = numerosDisponibles[indiceAleatorio];

                // Mostrar el número en la pantalla
                numeroSorteadoDisplay.textContent = numeroSorteado < 10 ? `0${numeroSorteado}` : numeroSorteado;

                // Marcar el número como sorteado en la lista
                const numeroElemento = document.querySelector(`.numero-item[data-numero="${numeroSorteado}"]`);
                if (numeroElemento) {
                    numeroElemento.classList.add('sorteado');
                }

                // Eliminar el número sorteado de la lista de disponibles
                numerosDisponibles.splice(indiceAleatorio, 1);
            };

            // Generar la lista de números al cargar la página
            generarListaNumeros();

            // Asignar el evento al botón
            sortearBtn.addEventListener('click', sortearNumero);
        });
    </script>
</body>
</html>
