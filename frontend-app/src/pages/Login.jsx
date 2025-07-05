import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles/App.css";


function Login() {
  const navigate = useNavigate();

  return (
    <div className="container">
      <h1>Login de supervisor</h1>

      <div>
        <input type="text" placeholder="Cédula" />
      </div>

      <div>
        <input type="password" placeholder="Password" />
      </div>

      <div>
        <button onClick={() => alert("Login exitoso")}>Ingresar</button>
      </div>

      <div>
        <button onClick={() => navigate("/")}>Volver</button>
      </div>
    </div>
  );
}

export default Login;
