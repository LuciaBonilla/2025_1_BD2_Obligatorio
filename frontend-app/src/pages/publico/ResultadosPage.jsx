import { useEffect, useState } from "react";
import { getResultados } from "@/services/resultadosService";
import { useNavigate } from "react-router-dom";

export default function ResultadosPage() {
  const [resultados, setResultados] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    (async () => {
      try {
        const data = await getResultados();
        setResultados(data);
      } catch {
        alert("Error al cargar resultados");
      }
    })();
  }, []);

  if (!resultados) return <p>Cargando resultados...</p>;

  if (resultados.error) return <p>{resultados.error}</p>;

  return (
    <div>
      <h1>Resultados de la Última Votación</h1>

      <section>
        <h2>Resumen General a Nivel País</h2>
        <ul>
          <li><strong>Personas habilitadas:</strong> {resultados.Personas_Habilitadas?.Cantidad ?? "-"}</li>
          <li><strong>Votos emitidos:</strong> {resultados.Votos_Emitidos?.Cantidad ?? "-"} ({resultados.Votos_Emitidos?.Porcentaje ?? "0"}%)</li>
          <li><strong>Votos válidos:</strong> {resultados.Votos_Validos?.Cantidad ?? "-"} ({resultados.Votos_Validos?.Porcentaje ?? "0"}%)</li>
          <li><strong>Votos en blanco:</strong> {resultados.Votos_En_Blanco?.Cantidad ?? "-"} ({resultados.Votos_En_Blanco?.Porcentaje ?? "0"}%)</li>
          <li><strong>Votos anulados:</strong> {resultados.Votos_Anulados?.Cantidad ?? "-"} ({resultados.Votos_Anulados?.Porcentaje ?? "0"}%)</li>
        </ul>
      </section>

      <section>
        <h2>Votos por Fórmula</h2>
        {resultados.Votos_Por_Formula.length === 0 ? (
          <p>No se registraron votos por fórmula.</p>
        ) : (
          <ul>
            {resultados.Votos_Por_Formula.map((formula, idx) => (
              <li key={idx}>
                <strong>{formula.Partido}:</strong> {formula.Cantidad} votos ({formula.Porcentaje}%)
              </li>
            ))}
          </ul>
        )}
      </section>

      <button onClick={() => navigate("/")}>Volver al inicio</button>
    </div>
  );
}
