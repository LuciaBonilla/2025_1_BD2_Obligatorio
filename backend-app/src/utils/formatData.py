import datetime
from zoneinfo import ZoneInfo

@staticmethod
def format_circuito_result(result):
    """
        Para formatear las fechas en algo que se pueda poner en JSON.
    """
    if not result:
        return None

    fecha_votacion = result.get("Fecha_Votacion")  # datetime.date
    hora_inicio = result.get("Hora_Inicio_Votacion")  # datetime.timedelta
    hora_fin = result.get("Hora_Fin_Votacion")  # datetime.timedelta

    uruguay_tz = ZoneInfo("America/Montevideo")

    # Construir datetime de inicio votación
    if fecha_votacion and hora_inicio is not None:
        inicio_dt = datetime.datetime.combine(fecha_votacion, datetime.time.min) + hora_inicio
        inicio_dt = inicio_dt.replace(tzinfo=uruguay_tz)
        result["Hora_Inicio_Votacion"] = inicio_dt.strftime("%Y-%m-%d %H:%M:%S %Z")

    # Construir datetime de fin votación
    if fecha_votacion and hora_fin is not None:
        fin_dt = datetime.datetime.combine(fecha_votacion, datetime.time.min) + hora_fin
        fin_dt = fin_dt.replace(tzinfo=uruguay_tz)
        result["Hora_Fin_Votacion"] = fin_dt.strftime("%Y-%m-%d %H:%M:%S %Z")

    return result
