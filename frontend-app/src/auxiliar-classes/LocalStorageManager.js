/**
 * Permite guardar y cargar el contexto de autenticación en el LocalStorage.
 * @estado clase terminada.
 */
export default class LocalStorageManager {
    /**
     * Guarda el contexto de autenticación en el LocalStorage.
     * @param {*} cedulaReceptor 
     * @param {*} accessToken
     * @param {*} refreshToken
     * @estado método terminado.
     */
    static saveAuthContextToStorage(cedulaReceptor, accessToken, refreshToken) {
        localStorage.setItem("cedulaReceptor", cedulaReceptor);
        localStorage.setItem("accessToken", accessToken);
        localStorage.setItem("refreshToken", refreshToken);
    }

    /**
     * Recarga el contexto de autenticación desde el LocalStorage a un objeto plano.
     * @returns Objeto plano con todo el contexto de autenticación.
     * @estado método terminado.
     */
    static loadAuthContextFromStorage() {
        return {
            cedulaReceptor: localStorage.getItem("cedulaReceptor"),
            accessToken: localStorage.getItem("accessToken"),
            refreshToken: localStorage.getItem("refreshToken")
        }
    }
}