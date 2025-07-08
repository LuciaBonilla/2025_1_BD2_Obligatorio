import { useNavigate } from "react-router-dom";

export default function ConfirmacionVotoPage() {
  const navigate = useNavigate();

  return (
    <div>
      <h1>Gracias por Votar</h1>
      <button onClick={() => navigate("/")}>
        Volver
      </button>
    </div>
  );
}

