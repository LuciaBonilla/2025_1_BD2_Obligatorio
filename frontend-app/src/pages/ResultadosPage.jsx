import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles/App.css";


const resultadosSimulados = [
  { id: 1, nombre: "Partido Rojo", votos: 350 },
  { id: 2, nombre: "Partido Verde", votos: 280 },
  { id: 3, nombre: "Partido Azul", votos: 200 },
  { id: 4, nombre: "Partido Amarillo", votos: 150 },
  { id: 5, nombre: "Partido Naranja", votos: 100 },
];

function ResultadosPage() {
  const navigate = useNavigate();

  // Ordenar descendente por votos
  const top5 = resultadosSimulados
    .sort((a, b) => b.votos - a.votos)
    .slice(0, 5);

  const posiciones = ["Primer lugar", "Segundo lugar", "Tercer lugar", "Cuarto lugar", "Quinto lugar"];

  return (
    <div className="container">
      <h1>Resultados de la votación</h1>

      <ul className="lista">
        {top5.map((lista, index) => (
          <li key={lista.id} style={{ fontWeight: "bold" }}>
            {posiciones[index]}: {lista.nombre} — {lista.votos} votos
          </li>
        ))}

        {top5.length === 0 && <li>No hay resultados disponibles.</li>}
      </ul>

      <button onClick={() => navigate("/")}>Volver</button>
    </div>
  );
}

export default ResultadosPage;
