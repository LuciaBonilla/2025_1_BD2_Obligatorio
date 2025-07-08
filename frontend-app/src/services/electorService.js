import BACKEND_URI from "./BACKEND_URI";
//
const API = BACKEND_URI;

export async function getElectorByCedula(cedula, accessToken) {
  const res = await fetch(`${API}/elector/${cedula}`, {
    headers: {
      Authorization: `Bearer ${accessToken}`,
    },
  });
  if (!res.ok) {
    const err = await res.json();
    throw new Error(err.error || "Error al obtener elector por cédula");
  }
  return res.json();
}

export async function getElectorByCredencial(serie, numero, accessToken) {
  const res = await fetch(`${API}/elector/${serie}/${numero}`, {
    headers: {
      Authorization: `Bearer ${accessToken}`,
    },
  });
  if (!res.ok) {
    const err = await res.json();
    throw new Error(err.error || "Error al obtener elector por credencial");
  }
  return res.json();
}

