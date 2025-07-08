import BACKEND_URI from "./BACKEND_URI";
//
const API = BACKEND_URI;

export async function getResultados() {
  const res = await fetch(`${API}/resultados/`, {
    method: "GET",
  });
  if (!res.ok) throw new Error("Error al obtener resultados");
  return res.json();
}
