import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles/App.css";


function HabilitarVotoPage() {
  const navigate = useNavigate();

  return (
    <div className="container">
      <h1>Habilitador para votar</h1>

      <div>
        <input type="text" placeholder="Credencial" />
      </div>

      <div>
        <button onClick={() => alert("Credencial verificada")}>Aceptar</button>
      </div>

      <div>
        <button onClick={() => navigate("/")}>Volver</button>
      </div>
    </div>
  );
}

export default HabilitarVotoPage;
