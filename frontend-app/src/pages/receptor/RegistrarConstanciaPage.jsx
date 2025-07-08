import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";

import { registrarConstancia } from "@/services/constanciaService";
import { getTiposObservacion } from "@/services/constanciaService";
import { getElectorByCedula, getElectorByCredencial } from "@/services/electorService";

export default function RegistrarConstanciaPage() {
  const { codigoCircuito, accessToken } = useAuth();
  const navigate = useNavigate();

  const [cedulaVotante, setCedulaVotante] = useState("");
  const [serieCredencial, setSerieCredencial] = useState("");
  const [numeroCredencial, setNumeroCredencial] = useState("");
  const [elector, setElector] = useState(null);
  const [tipoObservacion, setTipoObservacion] = useState("");
  const [comentarios, setComentarios] = useState("");
  const [tiposObservacion, setTiposObservacion] = useState([]);
  const [loadingTipos, setLoadingTipos] = useState(false);
  const [loadingElector, setLoadingElector] = useState(false);
  const [errorElector, setErrorElector] = useState(null);

  useEffect(() => {
    async function fetchTipos() {
      setLoadingTipos(true);
      try {
        const tipos = await getTiposObservacion();
        setTiposObservacion(tipos);
      } catch {
        alert("Error cargando tipos de observación");
      } finally {
        setLoadingTipos(false);
      }
    }
    fetchTipos();
  }, []);

  const buscarPorCedula = async () => {
    if (!cedulaVotante) {
      alert("Ingrese cédula para buscar");
      return;
    }
    setLoadingElector(true);
    setErrorElector(null);
    try {
      const result = await getElectorByCedula(cedulaVotante, accessToken);
      setElector(result);
    } catch (e) {
      setElector(null);
      setErrorElector(e.message || "Elector no encontrado");
    } finally {
      setLoadingElector(false);
    }
  };

  const buscarPorCredencial = async () => {
    if (!serieCredencial || !numeroCredencial) {
      alert("Ingrese serie y número de credencial");
      return;
    }
    setLoadingElector(true);
    setErrorElector(null);
    try {
      const result = await getElectorByCredencial(serieCredencial, numeroCredencial, accessToken);
      setElector(result);
    } catch (e) {
      setElector(null);
      setErrorElector(e.message || "Elector no encontrado");
    } finally {
      setLoadingElector(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!codigoCircuito) {
      alert("Código de circuito no disponible");
      return;
    }
    try {
      await registrarConstancia({
        Cedula_Votante: cedulaVotante,
        Codigo_Circuito: codigoCircuito,
        Codigo_Tipo_observacion: tipoObservacion,
        Comentarios_Observacion: comentarios,
      }, accessToken);
      alert("Constancia registrada con éxito");
    } catch (e) {
      alert(e.message || "Error registrando constancia");
    }
  };

  return (
    <div>
      <button onClick={() => navigate("/receptor/dashboard")}>Volver al Dashboard</button>

      <h2>Buscar Elector</h2>
      <div>
        <label>
          Buscar por Cédula:
          <input
            type="text"
            value={cedulaVotante}
            onChange={(e) => setCedulaVotante(e.target.value)}
            placeholder="Cédula"
          />
          <button onClick={buscarPorCedula} disabled={loadingElector}>
            {loadingElector ? "Buscando..." : "Buscar"}
          </button>
        </label>
      </div>

      <div>
        <label>
          Buscar por Credencial Cívica:
          <input
            type="text"
            value={serieCredencial}
            onChange={(e) => setSerieCredencial(e.target.value.toUpperCase())}
            placeholder="Serie"
            maxLength={3}
          />
          <input
            type="number"
            value={numeroCredencial}
            onChange={(e) => setNumeroCredencial(e.target.value)}
            placeholder="Número"
          />
          <button onClick={buscarPorCredencial} disabled={loadingElector}>
            {loadingElector ? "Buscando..." : "Buscar"}
          </button>
        </label>
      </div>

      {elector && (
        <div>
          <h3>Datos del Elector Encontrado:</h3>
          <p><strong>Cédula:</strong> {elector.Cedula_Identidad}</p>
          <p><strong>Nombre:</strong> {elector.Nombre}</p>
          <p><strong>Apellido:</strong> {elector.Apellido}</p>
          <p><strong>Fecha de Nacimiento:</strong> {elector.Fecha_Nacimiento}</p>
          <p><strong>Serie Cívica:</strong> {elector.Serie_Credencial_Civica}</p>
          <p><strong>Número Credencial:</strong> {elector.Numero_Credencial_Civica}</p>
        </div>
      )}

      {errorElector && <p style={{ color: "red" }}>{errorElector}</p>}

      <h2>Registrar Constancia de Voto</h2>
      <form onSubmit={handleSubmit}>
        <label>
          Cédula del votante:
          <input
            type="text"
            value={cedulaVotante}
            onChange={(e) => setCedulaVotante(e.target.value)}
            required
          />
        </label>

        <label>
          Tipo de observación:
          {loadingTipos ? (
            <p>Cargando tipos...</p>
          ) : (
            <select
              value={tipoObservacion}
              onChange={(e) => setTipoObservacion(e.target.value)}
              required
            >
              <option value="">-- Seleccione --</option>
              {tiposObservacion.map((tipo) => (
                <option key={tipo.Codigo} value={tipo.Codigo}>
                  {tipo.Nombre}
                </option>
              ))}
            </select>
          )}
        </label>

        <label>
          Comentarios:
          <textarea
            value={comentarios}
            onChange={(e) => setComentarios(e.target.value)}
            rows={4}
          />
        </label>

        <button type="submit">Registrar constancia</button>
      </form>
    </div>
  );
}
