import { Navigate } from "react-router-dom";

// PROVEEDOR DE CONTEXTO.
import { useAuthContext } from "../context-providers/AuthContextProvider";
import BackendCaller from "../auxiliar-classes/BackendCaller";

import routes from "../constants/routes";

/**
 * Protege una ruta privada no renderizando el contenido si el usuario no está autenticado.
 * @param {*} children 
 * @returns Si el usuario no está autenticado, entonces redirige a "/login". En caso contrario,
 * renderiza el contenido protegido.
 * @estado TERMINADO.
 */
export default function ProtectedRoute({ children }) {
    const { accessToken } = useAuthContext();

    let canPass = BackendCaller.checkAccessToken(accessToken).data.canPass

    // Si no está autenticado, redirige a la page de login.
    if (canPass === true) {
        return <Navigate to={routes.LOGIN_ROUTE} />;
    }

    // Si está autenticado, renderiza el contenido.
    return children;
}