import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "../styles/App.css";


function SupervisorPanel() {
  const personas = [
    { id: 1, nombre: "Ana López", cedula: "12345678", credencial: "ABC123" },
    { id: 2, nombre: "Luis Gómez", cedula: "23456789", credencial: "DEF456" },
    { id: 3, nombre: "Sofía Pérez", cedula: "34567890", credencial: "GHI789" }
  ];

  const [cedulaFiltro, setCedulaFiltro] = useState("");
  const [credencialFiltro, setCredencialFiltro] = useState("");

  const navigate = useNavigate();

  const filtradas = personas.filter((p) => {
    return (
      p.cedula.includes(cedulaFiltro) &&
      p.credencial.toLowerCase().includes(credencialFiltro.toLowerCase())
    );
  });

  return (
    <div className="container">
      <h1>Panel del supervisor</h1>

      <div className="filtros">
        <input
          type="text"
          placeholder="Buscar por cédula"
          value={cedulaFiltro}
          onChange={(e) => setCedulaFiltro(e.target.value)}
        />
        <input
          type="text"
          placeholder="Buscar por credencial"
          value={credencialFiltro}
          onChange={(e) => setCredencialFiltro(e.target.value)}
        />
      </div>

      <h2>Personas habilitadas</h2>
      <ul className="lista">
        {filtradas.map((p) => (
          <li key={p.id}>
            <span>
              {p.nombre} — Cédula: {p.cedula} — Credencial: {p.credencial}
            </span>
            <button onClick={() => navigate(`/constancia/${p.id}`)}>
              Registrar constancia de voto
            </button>
          </li>
        ))}
        {filtradas.length === 0 && <li>No hay resultados.</li>}
      </ul>
    </div>
  );
}

export default SupervisorPanel;
