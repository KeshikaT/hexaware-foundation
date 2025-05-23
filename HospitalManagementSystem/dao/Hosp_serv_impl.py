import pyodbc
from dao.Hosp_serv_interface import IHospitalService
from entity.appointment import Appointment
from util.db_conn_util import DBConnection
from exceptions.patient_notfound import PatientNumberNotFoundException

class HospitalServiceImpl(IHospitalService):
    def __init__(self):
        self.conn = DBConnection.get_connection()

    def get_appointment_by_id(self, appointment_id: int) -> Appointment:
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM Appointment WHERE appointmentId = ?", appointment_id)
        row = cursor.fetchone()
        if row:
            return Appointment(*row)
        return None

    def get_appointments_for_patient(self, patient_id: int):
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM Appointment WHERE patientId = ?", (patient_id,))
        rows = cursor.fetchall()

        if not rows:
            raise PatientNumberNotFoundException(f"No appointments found for patient ID: {patient_id}")
        
        return [Appointment(*row) for row in rows]


    def get_appointments_for_doctor(self, doctor_id: int):
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM Appointment WHERE doctorId = ?", (doctor_id,))
        rows = cursor.fetchall()
        return [Appointment(*row) for row in rows]

    def schedule_appointment(self, appointment: Appointment) -> bool:
        cursor = self.conn.cursor()
        try:
            cursor.execute(
                "INSERT INTO Appointment (appointmentId, patientId, doctorId, appointmentDate, description) "
                "VALUES (?, ?, ?, ?, ?)",
                appointment.get_appointment_id(),
                appointment.get_patient_id(),
                appointment.get_doctor_id(),
                appointment.get_appointment_date(),
                appointment.get_description()
            )
            self.conn.commit()
            return True
        except pyodbc.Error as e:
            print("Failed to schedule appointment:", e)
            return False

    def update_appointment(self, appointment: Appointment) -> bool:
        cursor = self.conn.cursor()
        try:
            cursor.execute(
                "UPDATE Appointment SET patientId=?, doctorId=?, appointmentDate=?, description=? "
                "WHERE appointmentId=?",
                appointment.get_patient_id(),
                appointment.get_doctor_id(),
                appointment.get_appointment_date(),
                appointment.get_description(),
                appointment.get_appointment_id()
            )
            self.conn.commit()
            return cursor.rowcount > 0
        except pyodbc.Error as e:
            print("Failed to update appointment:", e)
            return False

    def cancel_appointment(self, appointment_id: int) -> bool:
        cursor = self.conn.cursor()
        try:
            cursor.execute("DELETE FROM Appointment WHERE appointmentId = ?", (appointment_id,))
            self.conn.commit()
            return cursor.rowcount > 0
        except pyodbc.Error as e:
            print("Failed to cancel appointment:", e)
            return False
        
    def get_all_appointments(self):
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM Appointment")
        rows = cursor.fetchall()

        return [Appointment(*row) for row in rows]

