import BACKEND_URI from "./BACKEND_URI";
//
const API = BACKEND_URI;

export async function registrarConstancia(data, accessToken) {
  const res = await fetch(`${API}/constancia/registrar`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${accessToken}`,
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error("Error al registrar constancia");
  return res.json();
}

export async function getTiposObservacion() {
  const res = await fetch(`${API}/tipos/observacion`);
  if (!res.ok) {
    const err = await res.json();
    throw new Error(err.error || "Error al obtener tipos de observación");
  }
  return res.json();
}
