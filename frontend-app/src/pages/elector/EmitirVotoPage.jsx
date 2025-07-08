import { useEffect, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { getHojasVotacion, emitirVoto, getTiposVoto } from "@/services/votoService";

export default function EmitirVotoPage() {
  const location = useLocation();
  const navigate = useNavigate();
  const voteToken = location.state?.voteToken || null;
  const codigoCircuito = location.state?.codigoCircuito || null;

  const [hojas, setHojas] = useState([]);
  const [tiposVoto, setTiposVoto] = useState([]);
  const [tipoVoto, setTipoVoto] = useState("");
  const [hojaSeleccionada, setHojaSeleccionada] = useState("");

  useEffect(() => {
    if (!voteToken || !codigoCircuito) {
      alert("No autorizado para emitir voto");
      navigate("/elector/habilitar-voto");
      return;
    }

    const fetchData = async () => {
      try {
        const [hojasData, tiposData] = await Promise.all([
          getHojasVotacion(voteToken),
          getTiposVoto()
        ]);

        setHojas(hojasData || []);
        setTiposVoto(tiposData || []);
      } catch (e) {
        alert(e.message || "Error al cargar datos de votación");
      }
    };

    fetchData();
  }, [voteToken, codigoCircuito, navigate]);

  const requiereHoja = Number(tipoVoto) === 0;

  const handleSubmit = async () => {
    if (!tipoVoto) {
      alert("Seleccione un tipo de voto");
      return;
    }

    if (requiereHoja && !hojaSeleccionada) {
      alert("Debe seleccionar una hoja de votación para voto válido");
      return;
    }

    try {
      await emitirVoto(
        {
          Codigo_Tipo: requiereHoja ? null : Number(tipoVoto),
          Codigo_Hoja: requiereHoja ? Number(hojaSeleccionada) : null,
          Codigo_Circuito: codigoCircuito,
        },
        voteToken
      );

      setHojaSeleccionada("");
      setTipoVoto("");
      navigate("/elector/confirmacion-voto", {
        replace: true,
        state: {},
      });
    } catch (e) {
      alert(e.message || "Error al emitir voto");
    }
  };

  return (
    <div>
      <h1>Emitir Voto</h1>

      <label>
        Tipo de voto:
        <select
          value={tipoVoto}
          onChange={(e) => setTipoVoto(e.target.value)}
          required
        >
          <option value="">-- Seleccione --</option>
          <option value={0}>Hoja</option>
          {tiposVoto.map((tipo) => (
            <option key={tipo.Codigo} value={tipo.Codigo}>
              {tipo.Nombre}
            </option>
          ))}
        </select>
      </label>

      {requiereHoja && (
        <label>
          Hoja de votación:
          <select
            value={hojaSeleccionada}
            onChange={(e) => setHojaSeleccionada(e.target.value)}
            required
          >
            <option value="">-- Seleccione --</option>
            {hojas.map((hoja) => (
              <option key={hoja.Codigo_Hoja} value={hoja.Codigo_Hoja}>
                Partido: {hoja.Partido_Politico} - Hoja: {hoja.Numero}
              </option>
            ))}
          </select>
        </label>
      )}

      <button onClick={handleSubmit}>Emitir voto</button>
    </div>
  );
}
