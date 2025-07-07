import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import "../styles/App.css";
import { useAuthContext } from "../context-providers/AuthContextProvider";
import routes from "../constants/routes";
import BackendCaller from "../auxiliar-classes/BackendCaller";

function LoginPage() {
  // Para cambiar de ruta.
    const navigate = useNavigate();

    // Iniciar sesión.
    const { login, accessToken } = useAuthContext();

    // Valores de los inputs.
    const [cedulaReceptor, setCedulaReceptor] = useState(0);
    const [password, setPassword] = useState("");

    /**
     * Maneja el inicio de sesión de un usuario.
     * @param {*} event 
     */
    async function handleLogin(event) {
        // Para evitar el submit.
        event.preventDefault();

        // Resultado del login.
        const result = await login(cedulaReceptor, password);

        if (!result.success) {
            alert("Cédula y/o contraseña invalidos")
        }
    }

    // Para cerrar sesión.
    const { logout } = useAuthContext();

    useEffect(() => {
        let canPass = BackendCaller.checkAccessToken(accessToken).data.canPass
        if ( canPass === true) {
            navigate(routes.LEGAJO_ROUTE);
        }
    }, [accessToken])

    useEffect(() => {
        // Cada vez que se renderiza esta page, entonces se cierra la sesión.
        logout();
    }, []);

  async function handleLogin() {
    const result = await login(cedulaReceptor, password)

    if (result )
    navigate(routes.LEGAJO_ROUTE)
  }

  return (
    <div className="container">
      <h1>Iniciar sesión para supervisores de mesa</h1>

      <div>
        <input type="number" placeholder="Cédula" onChange={(event) => setCedulaReceptor(event.target.value)} value={cedulaReceptor}/>
      </div>

      <div>
        <input type="password" placeholder="Password" onChange={(event) => setPassword(event.target.value)} value={password}/>
      </div>

      <div>
        <button onClick={() => handleLogin}>Ingresar</button>
      </div>

      <div>
        <button onClick={() => navigate("/")}>Volver</button>
      </div>
    </div>
  );
}

export default LoginPage;
