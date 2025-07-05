import { Routes, Route, Navigate } from "react-router-dom";

import PantallaPrincipal from "./pages/PantallaPrincipal";
import Login from "./pages/Login";
import Votar from "./pages/Votar";
import SupervisorPanel from "./pages/SupervisorPanel";
import RegistrarConstancia from "./pages/RegistrarConstancia";
import EmitirVoto from "./pages/EmitirVoto";
import Resultados from "./pages/Resultados";

export default function AppRouter() {
  return (
    <Routes>
      <Route path="/" element={<PantallaPrincipal />} />
      <Route path="/login" element={<Login />} />
      <Route path="/votar" element={<Votar />} />
      <Route path="/supervisor" element={<SupervisorPanel />} />
      <Route path="/constancia/:id" element={<RegistrarConstancia />} />
      <Route path="/emitir-voto" element={<EmitirVoto />} />
      <Route path="/resultados" element={<Resultados />} />
      <Route path="*" element={<h1>Página no encontrada.</h1>} />
    </Routes>
  );
}
