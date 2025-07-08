import React, { createContext, useContext, useState, useEffect } from "react";

const AuthContext = createContext();

// Cuando se viaja entre páginas no se borran las variables del conteto (sólo se borran si se recarga o cierra).
export function AuthProvider({ children }) {
  const [accessToken, setAccessToken] = useState(null);
  const [refreshToken, setRefreshToken] = useState(null);
  const [codigoCircuito, setCodigoCircuito] = useState(null);

  const login = (access, refresh, codigo) => {
    setAccessToken(access);
    setRefreshToken(refresh);
    setCodigoCircuito(codigo);
  };

  const logout = () => {
    setAccessToken(null);
    setRefreshToken(null);
    setCodigoCircuito(null);
  };

  const updateAccessToken = (newAccessToken) => {
    setAccessToken(newAccessToken);
  };

  return (
    <AuthContext.Provider
      value={{
        accessToken,
        refreshToken,
        codigoCircuito,
        login,
        logout,
        updateAccessToken,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
