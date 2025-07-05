import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles/App.css";

function PantallaPrincipal() {
  const navigate = useNavigate();

  return (
    <div className="container">
      <h1>Pantalla principal</h1>
      <button onClick={() => navigate("/login")}>Login de supervisor</button>
      <br />
      <button onClick={() => navigate("/votar")}>Votar</button>
      <br />
      <button onClick={() => navigate("/resultados")}>Ver resultados</button>
    </div>
  );
}

export default PantallaPrincipal;
