// src/pages/receptor/DashboardPage.jsx
import { useAuth } from "@/context/AuthContext";
import { useNavigate } from "react-router-dom";
import { abrirCircuito, cerrarCircuito, getCircuito } from "@/services/circuitoService";
import { useState, useEffect } from "react";

export default function DashboardPage() {
  const { codigoCircuito, accessToken, logout } = useAuth();
  const navigate = useNavigate();
  const [estado, setEstado] = useState("Desconocido");

  useEffect(() => {
    const fetchEstado = async () => {
      try {
        const circuito = await getCircuito(codigoCircuito, accessToken);
        setEstado(circuito.Esta_Cerrado ? "Cerrado" : "Abierto");
      } catch (e) {
        console.error(e);
        setEstado("Desconocido");
      }
    };

    if (codigoCircuito) {
      fetchEstado();
    }
  }, [codigoCircuito, accessToken]);

  const handleGoToRegistrarConstancia = () => {
    navigate("/receptor/registrar-constancia");
  };

  const handleAbrirCircuito = async () => {
    try {
      await abrirCircuito(codigoCircuito, accessToken);
      setEstado("Abierto");
      alert("Circuito abierto correctamente");
    } catch (e) {
      alert(e.message || "Error abriendo el circuito");
    }
  };

  const handleCerrarCircuito = async () => {
    try {
      await cerrarCircuito(codigoCircuito, accessToken);
      setEstado("Cerrado");
      alert("Circuito cerrado correctamente");
    } catch (e) {
      alert(e.message || "Error cerrando el circuito");
    }
  };

  return (
    <div>
      <h1>Dashboard del Receptor</h1>
      <p>Código de circuito asignado: {codigoCircuito || "No asignado"}</p>
      <p>Estado del circuito: {estado}</p>

      <button onClick={handleAbrirCircuito}>Abrir circuito</button>
      <button onClick={handleCerrarCircuito}>Cerrar circuito</button>
      <br />
      <button onClick={handleGoToRegistrarConstancia}>
        Registrar Constancia de Voto
      </button>
      <button onClick={logout}>Cerrar sesión</button>
    </div>
  );
}
