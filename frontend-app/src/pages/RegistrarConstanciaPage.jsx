import React, { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import "../styles/App.css";


const personas = [
  { id: 1, nombre: "Ana López", cedula: "12345678", credencial: "ABC123" },
  { id: 2, nombre: "Luis Gómez", cedula: "23456789", credencial: "DEF456" },
  { id: 3, nombre: "Sofía Pérez", cedula: "34567890", credencial: "GHI789" }
];

function RegistrarConstanciaPage() {
  const { id } = useParams();
  const navigate = useNavigate();

  const persona = personas.find((p) => p.id === Number(id));

  const [tipoObs, setTipoObs] = useState("");
  const [comentario, setComentario] = useState("");

  if (!persona) {
    return <p>Persona no encontrada.</p>;
  }

  const handleAceptar = () => {
    alert(
      `Constancia registrada para ${persona.nombre}.\n` +
        `Tipo de observación: ${tipoObs || "Ninguna"}\n` +
        `Comentario: ${comentario || "Ninguno"}`
    );
    navigate("/supervisor");
  };

  return (
    <div className="container">
      <h1>Registro de constancia de voto</h1>

      <p>
        <strong>Nombre:</strong> {persona.nombre}
      </p>
      <p>
        <strong>Credencial:</strong> {persona.credencial}
      </p>

      <div>
        <label>
          Tipo de observación:{" "}
          <select
            value={tipoObs}
            onChange={(e) => setTipoObs(e.target.value)}
          >
            <option value="">-- Ninguna --</option>
            <option value="simple">Simple</option>
            <option value="identidad">Por identidad</option>
          </select>
        </label>
      </div>

      {tipoObs && (
        <div>
          <textarea
            placeholder="Comentario"
            value={comentario}
            onChange={(e) => setComentario(e.target.value)}
            rows={4}
          />
        </div>
      )}

      <button onClick={handleAceptar}>Aceptar</button>
    </div>
  );
}

export default RegistrarConstanciaPage;
