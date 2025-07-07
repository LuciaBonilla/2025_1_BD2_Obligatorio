import { useNavigate } from "react-router-dom";
import "../styles/App.css";
import routes from "../constants/routes";

function HomePage() {
  const navigate = useNavigate();

  return (
    <div className="container">
      <h1>Pantalla principal</h1>
      <button onClick={() => navigate(routes.LOGIN_ROUTE)}>Iniciar sesión para supervisores de mesa</button>
      <br />
      <button onClick={() => navigate(routes.HABILITAR_VOTO_ROUTE)}>Votar</button>
      <br />
      <button onClick={() => navigate(routes.RESULTADOS_ROUTE)}>Ver resultados de la votación</button>
    </div>
  );
}

export default HomePage;