import { createContext, useContext, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

// CLASES AUXILIARES.
import BackendCaller from "../auxiliar-classes/BackendCaller";
import LocalStorageManager from "../auxiliar-classes/LocalStorageManager";

// Contexto de autenticación.
const AuthContext = createContext();

/**
 * Provee del contexto de autenticación.
 * @param {*} children - Hijos a pasarle el contexto.
 * @estado Componente terminado.
 */
export function AuthContextProvider({ children }) {
    const navigate = useNavigate();

    // Estado del contexto de autenticación.
    const [cedulaReceptor, setCedulaReceptor] = useState();
    const [accessToken, setAccessToken] = useState();
    const [refreshToken, setRefreshToken] = useState();

    // Para controlar el estado de carga.
    const [loading, setLoading] = useState(true);

    // Recarga los valores del LocalStorage cuando el componente se monta.
    useEffect(() => {
        const context = LocalStorageManager.loadAuthContextFromStorage();
        setCedulaReceptor(context.cedulaReceptor);
        setAccessToken(context.accessToken);
        setRefreshToken(context.refreshToken);

        // Indica que la carga ha terminado.
        setLoading(false);
    }, []);

    // Actualiza el LocalStorage cada vez que cambien los valores del contexto de autenticación.
    useEffect(() => {
        if (!loading) {
            LocalStorageManager.saveAuthContextToStorage(cedulaReceptor, accessToken, refreshToken);
        }
    }, [cedulaReceptor, accessToken, refreshToken]);

    /**
     * Inicia sesión.
     * @param {*} cedulaReceptor 
     * @param {*} password 
     * @returns Resultado de la operación.
     */
    async function login(cedulaReceptor, password) {
        // Intenta iniciar sesión por backend.
        const response = await BackendCaller.login(cedulaReceptor, password);

        let result;
        switch (response.statusCode) {
            case 200: // OK.
                setCedulaReceptor(cedulaReceptor);
                setAccessToken(response.data.access_token);
                setRefreshToken(response.data.refresh_token);
                result = { success: true };
                break
            case 401 || 500: // Unauthorized o Internal Server Error.
                setCedulaReceptor();
                setAccessToken();
                setRefreshToken(false);
                result = { success: false, error: response.data.message };
                break;
            default:
                result = { success: false, message: "Ha ocurrido un error imprevisto." };
        }
        return result;
    }

    /**
     * Cierra sesión.
     */
    async function logout() {
        setCedulaReceptor();
        setAccessToken();
        setRefreshToken();
    }

    return (
        <>
            {
                loading ? (
                    // Mientras se cargan los datos del LocalStorage, evita renderizar los hijos.
                    <div className="loading-container">
                        <p className="loading-message">CARGANDO...</p>
                        <button onClick={() => navigate("/")}>Volver</button>
                    </div>
                ) : (
                    <AuthContext.Provider value={{ cedulaReceptor, accessToken, refreshToken, login, logout }}>
                        {children}
                    </AuthContext.Provider>)
            }
        </>
    );
}

export function useAuthContext() {
    return useContext(AuthContext);
}