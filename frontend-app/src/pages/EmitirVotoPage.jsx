import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "../styles/App.css";


const partidos = [
  { id: 1, nombre: "Partido Rojo", hoja: "101" },
  { id: 2, nombre: "Partido Verde", hoja: "202" },
  { id: 3, nombre: "Partido Azul", hoja: "303" }
];

function EmitirVotoPage() {
  const [filtroHoja, setFiltroHoja] = useState("");
  const [filtroNombre, setFiltroNombre] = useState("");
  const [seleccionado, setSeleccionado] = useState(null);
  const navigate = useNavigate();

  const partidosFiltrados = partidos.filter(
    (p) =>
      p.hoja.includes(filtroHoja) &&
      p.nombre.toLowerCase().includes(filtroNombre.toLowerCase())
  );

  const manejarAceptar = () => {
    if (!seleccionado) {
      alert("Debe seleccionar algo.");
      return;
    }
    alert(`Voto registrado para: ${seleccionado}`);
    navigate("/votar");
  };

  return (
    <div className="container">
      <h1>Emitir voto</h1>

      <div className="filtros">
        <input
          type="text"
          placeholder="Filtro por número de hoja"
          value={filtroHoja}
          onChange={(e) => setFiltroHoja(e.target.value)}
        />
        <input
          type="text"
          placeholder="Filtro por nombre de partido"
          value={filtroNombre}
          onChange={(e) => setFiltroNombre(e.target.value)}
        />
      </div>

      <h2>Partidos políticos</h2>
      <ul className="lista">
        {partidosFiltrados.map((p) => (
          <li key={p.id} className="lista-item">
            <label>
              <input
                type="radio"
                name="voto"
                value={p.nombre}
                checked={seleccionado === p.nombre}
                onChange={() => setSeleccionado(p.nombre)}
              />{" "}
              {p.hoja} - {p.nombre}
            </label>
          </li>
        ))}

        <li className="lista-item">
          <label>
            <input
              type="radio"
              name="voto"
              value="Voto en blanco"
              checked={seleccionado === "Voto en blanco"}
              onChange={() => setSeleccionado("Voto en blanco")}
            />{" "}
            Voto en blanco
          </label>
        </li>

        <li className="lista-item">
          <label>
            <input
              type="radio"
              name="voto"
              value="Voto anulado"
              checked={seleccionado === "Voto anulado"}
              onChange={() => setSeleccionado("Voto anulado")}
            />{" "}
            Botón anulado
          </label>
        </li>
      </ul>

      <button onClick={manejarAceptar}>Aceptar</button>
    </div>
  );
}

export default EmitirVotoPage;
