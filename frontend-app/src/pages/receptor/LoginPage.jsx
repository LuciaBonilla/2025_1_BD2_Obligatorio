import { useState } from "react";
import { useAuth } from "@/context/AuthContext";
import { loginReceptor } from "@/services/authService";
import { useNavigate } from "react-router-dom";

export default function LoginPage() {
  const [cedula, setCedula] = useState("");
  const [password, setPassword] = useState("");
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleGoToHome = () => {
    navigate("/");
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const data = await loginReceptor(cedula, password);
      // data: { Access_Token, Refresh_Token, Codigo_Circuito }
      login(data.Access_Token, data.Refresh_Token, data.Codigo_Circuito);
      alert("Login exitoso");
      navigate("/receptor/dashboard"); // Navegar después del login
    } catch (error) {
      alert(error.message || "Error en login");
    }
  };

  return (
    <div>
      <h1>Acceso para Receptores de Votos</h1>
      <form onSubmit={handleSubmit}>
        <input
          placeholder="Cédula"
          value={cedula}
          onChange={(e) => setCedula(e.target.value)}
        />
        <input
          type="password"
          placeholder="Contraseña"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        <button type="submit">Iniciar sesión</button>
      </form>
      <button onClick={handleGoToHome}>
        Volver a Inicio
      </button>
    </div>
  );
}


