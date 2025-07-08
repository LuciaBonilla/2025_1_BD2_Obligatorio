import BACKEND_URI from "./BACKEND_URI";
//
const API = BACKEND_URI;

export async function getHojasVotacion(voteToken) {
  const res = await fetch(`${API}/voto/hojas`, {
    headers: {
      Authorization: `Bearer ${voteToken}`,
    },
  });
  if (!res.ok) {
    const err = await res.json();
    throw new Error(err.error || "Error al obtener hojas de votación");
  }
  return res.json();
}

export async function emitirVoto(data, voteToken) {
  const res = await fetch(`${API}/voto/emitir-voto`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${voteToken}`,
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) {
    const err = await res.json();
    throw new Error(err.error || "Error al emitir voto");
  }
  return res.json();
}

export async function getTiposVoto() {
  const res = await fetch(`${API}/tipos/voto`);
  if (!res.ok) {
    const err = await res.json();
    throw new Error(err.error || "Error al obtener tipos de voto");
  }
  return res.json();
}

