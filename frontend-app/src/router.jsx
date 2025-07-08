import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

// PÁGINAS.
import LoginPage from "@/pages/receptor/LoginPage";
import DashboardPage from "@/pages/receptor/DashboardPage";
import RegistrarConstanciaPage from "@/pages/receptor/RegistrarConstanciaPage";
import HabilitarVotoPage from "@/pages/elector/HabilitarVotoPage";
import EmitirVotoPage from "@/pages/elector/EmitirVotoPage";
import ResultadosPage from "@/pages/publico/ResultadosPage";
import HomePage from "@/pages/publico/HomePage";
import ConfirmacionVotoPage from "@/pages/elector/ConfirmacionVotoPage";
import { AuthProvider, useAuth } from "@/context/AuthContext";

// Protege a las rutas.
// Si no hay token de acceso, se va para login si se va a una ruta protegida.
const PrivateRoute = ({ children }) => {
  const { accessToken } = useAuth();
  return accessToken ? children : <LoginPage />;
};

const AppRouter = () => (
  <Router>
    <AuthProvider>
      <Routes>
        {/* Rutas Públicas */}
        <Route path="/" element={<HomePage />} />
        <Route path="/resultados" element={<ResultadosPage />} />

        {/* Rutas para Receptor */}
        <Route path="/receptor/login" element={<LoginPage />} />
        <Route
          path="/receptor/dashboard"
          element={
            <PrivateRoute>
              <DashboardPage />
            </PrivateRoute>
          }
        />
        <Route
          path="/receptor/registrar-constancia"
          element={
            <PrivateRoute>
              <RegistrarConstanciaPage />
            </PrivateRoute>
          }
        />

        {/* Rutas para Elector */}
        <Route path="/elector/habilitar-voto" element={<HabilitarVotoPage />} />
        <Route path="/elector/emitir-voto" element={<EmitirVotoPage />} />
        <Route path="/elector/confirmacion-voto" element={<ConfirmacionVotoPage />} />
      </Routes>
    </AuthProvider>
  </Router>
);

export default AppRouter;
