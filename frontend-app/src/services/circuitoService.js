import BACKEND_URI from "./BACKEND_URI";

const API = BACKEND_URI;

export async function abrirCircuito(codigoCircuito, accessToken) {
  const res = await fetch(`${API}/circuito/${codigoCircuito}/abrir`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${accessToken}`,
    },
  });
  if (!res.ok) throw new Error("Error al abrir el circuito");
  return res.json();
}

export async function cerrarCircuito(codigoCircuito, accessToken) {
  const res = await fetch(`${API}/circuito/${codigoCircuito}/cerrar`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${accessToken}`,
    },
  });
  if (!res.ok) throw new Error("Error al cerrar el circuito");
  return res.json();
}

export async function getCircuito(codigoCircuito, accessToken) {
  const res = await fetch(`${API}/circuito/${codigoCircuito}`, {
    method: "GET",
    headers: {
      "Authorization": `Bearer ${accessToken}`,
    },
  });
  if (!res.ok) throw new Error("Error al obtener estado del circuito");
  return res.json();
}
