import smtplib
import random
import json
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


class ATM:
    def __init__(self):
        self.data_file = "user_data.json"
        self.pin = ""
        self.balance = 0
        self.email = ""
        self.load_data()

    def load_data(self):
        try:
            with open(self.data_file, "r") as file:
                data = json.load(file)
                self.pin = data.get("pin", "")
                self.balance = data.get("balance", 0)
                self.email = data.get("email", "")
        except FileNotFoundError:
            self.pin = ""
            self.balance = 0
            self.email = ""

    def save_data(self):
        data = {
            "pin": self.pin,
            "balance": self.balance,
            "email": self.email
        }
        with open(self.data_file, "w") as file:
            json.dump(data, file)

    def menu(self):
        user_input = input("""
            1. Press 1 -> Set Email and Generate PIN
            2. Press 2 -> Deposit Money                        
            3. Press 3 -> Change PIN
            4. Press 4 -> Check Balance
            5. Press 5 -> Withdraw Money
            6. Press 6 -> Exit
            
            Enter your Choice::
                         """)
        if user_input == "1":
            self.set_email_and_generate_pin()
        elif user_input == "2":
            self.deposit_money()
        elif user_input == "3":
            self.change_pin()
        elif user_input == "4":
            self.check_balance()
        elif user_input == "5":
            self.withdraw()
        else:
            exit()

    def generate_otp(self, length=6):
        otp = ''.join([str(random.randint(0, 9)) for _ in range(length)])
        return otp

    def send_otp(self, otp):
        sender_email = "yugchauhan3135@gmail.com"
        sender_password = "moex kzmm zvel iwht"
        smtp_server = "smtp.gmail.com"
        smtp_port = 587
        subject = "Your OTP Code"
        body = f"Your OTP is: {otp}. Please use it to complete your operation."
        
        message = MIMEMultipart()
        message["From"] = sender_email
        message["To"] = self.email
        message["Subject"] = subject
        message.attach(MIMEText(body, "plain"))

        try:
            with smtplib.SMTP(smtp_server, smtp_port) as server:
                server.starttls()
                server.login(sender_email, sender_password)
                server.sendmail(sender_email, self.email, message.as_string())
            print(f"OTP sent successfully to {self.email}")
        except Exception as e:
            print(f"Failed to send OTP: {e}")

    def verify_otp(self):
        otp = self.generate_otp()
        self.send_otp(otp)
        entered_otp = input("Enter the OTP sent to your email: ")
        if entered_otp == otp:
            print("OTP verified successfully!")
            return True
        else:
            print("Incorrect OTP.")
            return False

    def set_email_and_generate_pin(self):
        if len(self.pin) == 0:
            self.email = input("Enter your email address: ")
            if self.verify_otp():
                user_pin = input("Enter your new PIN: ")
                self.pin = user_pin
                print("Your PIN has been generated successfully.")
                self.save_data()
            else:
                print("Failed to verify OTP. Cannot generate PIN.")
        else:
            print("PIN is already generated.")
        self.menu()

    def deposit_money(self):
        user_pin = input("Enter PIN: ")
        if user_pin == self.pin:
            user_money = int(input("How much money do you want to deposit? "))
            self.balance += user_money
            print("Money deposited successfully.")
            self.save_data()
        else:
            print("Wrong PIN.")
        self.menu()

    def change_pin(self):
        if self.verify_otp():
            old_pin = input("Enter your current PIN: ")
            if old_pin == self.pin:
                new_pin = input("Enter your new PIN: ")
                self.pin = new_pin
                print("PIN changed successfully.")
                self.save_data()
            else:
                print("Incorrect current PIN.")
        else:
            print("Failed to verify OTP. Cannot change PIN.")
        self.menu()

    def check_balance(self):
        bal_pin = input("Enter PIN: ")
        if bal_pin == self.pin:
            print("Current Balance:", self.balance)
        else:
            print("Wrong PIN.")
        self.menu()

    def withdraw(self):
        with_pin = input("Enter PIN: ")
        if with_pin == self.pin:
            money = int(input("Enter amount to withdraw: "))
            if money <= self.balance:
                if money > 10000:
                    print("Withdrawal exceeds 10,000. OTP verification required.")
                    if self.verify_otp():
                        self.balance -= money
                        print(f"Successfully withdrawn {money}. Available Balance: {self.balance}")
                        self.save_data()
                    else:
                        print("Failed to verify OTP. Cannot withdraw money.")
                else:
                    self.balance -= money
                    print(f"Successfully withdrawn {money}. Available Balance: {self.balance}")
                    self.save_data()
            else:
                print("Insufficient balance.")
        else:
            print("Wrong PIN.")
        self.menu()


if __name__ == "__main__":
    user = ATM()
    user.menu()
