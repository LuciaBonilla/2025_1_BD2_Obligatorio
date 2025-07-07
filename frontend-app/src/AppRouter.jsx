import { Routes, Route } from "react-router-dom";

// RUTAS.
import routes from "./constants/routes"

import ProtectedRoute from "./routes-protection/ProtectedRoute"

import HomePage from "./pages/HomePage";
import LoginPage from "./pages/LoginPage";
import HabilitarVotoPage from "./pages/HabilitarVotoPage";
import LegajoPage from "./pages/LegajoPage";
import RegistrarConstanciaPage from "./pages/RegistrarConstanciaPage";
import EmitirVotoPage from "./pages/EmitirVotoPage";
import ResultadosPage from "./pages/ResultadosPage";

export default function AppRouter() {
  return (
    <Routes>
      <Route path="/" element={< HomePage />} />

      <Route path={routes.LOGIN_ROUTE} element={<LoginPage />} />

      <Route path={routes.HABILITAR_VOTO_ROUTE} element={
        <ProtectedRoute>
          <HabilitarVotoPage />
        </ProtectedRoute>
      } />

      <Route path={routes.LEGAJO_ROUTE} element={
        <ProtectedRoute>
          <LegajoPage />
        </ProtectedRoute>} />

      <Route path={routes.REGISTRAR_CONSTANCIA_ROUTE} element={
        <ProtectedRoute>
          <RegistrarConstanciaPage />
        </ProtectedRoute>
      } />

      <Route path={routes.EMITIR_VOTO_ROUTE} element={
        <ProtectedRoute>
          <EmitirVotoPage />
        </ProtectedRoute>
      } />

      <Route path={routes.RESULTADOS_ROUTE} element={<ResultadosPage />} />

      <Route path={routes.UNKNOWN_ROUTE} element={<h1>Página no encontrada.</h1>} />
    </Routes>
  );
}
