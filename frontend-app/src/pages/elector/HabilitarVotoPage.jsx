import { useState } from "react";
import { getVoteToken } from "@/services/authService";
import { useNavigate } from "react-router-dom";

export default function HabilitarVotoPage() {
  const [cedula, setCedula] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleEnableVote = async () => {
    try {
      const data = await getVoteToken(cedula, password);
      // Token de voto se pasa por location.state
      navigate("/elector/emitir-voto", {
        state: {
          voteToken: data.Vote_Token,
          codigoCircuito: data.Codigo_Circuito,
        },
      });
    } catch (e) {
      alert(e.message || "Error al habilitar voto");
    }
  };

  const handleGoBack = () => {
    navigate("/");
  };

  return (
    <div>
      <h1>Habilitar Voto para Elector</h1>
      
      <p>Sólo su receptor de mesa puede habilitarlo en este dispositivo.</p>

      <input
        placeholder="Cédula de receptor"
        value={cedula}
        onChange={(e) => setCedula(e.target.value)}
      />
      <input
        type="password"
        placeholder="Contraseña de receptor"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
      />

      <button onClick={handleEnableVote}>Habilitar voto</button>

      <button onClick={handleGoBack}>
        Volver al Inicio
      </button>
    </div>
  );
}
