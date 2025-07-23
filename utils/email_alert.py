import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def send_email_alert(subject, body, to_email, from_email, from_password):
    try:
        # Create message
        msg = MIMEMultipart()
        msg['From'] = from_email
        msg['To'] = to_email
        msg['Subject'] = subject
        msg.attach(MIMEText(body, 'plain'))

        # Connect to Gmail SMTP
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(from_email, from_password)
        server.send_message(msg)
        server.quit()

        print("✅ Email sent successfully!")
    except Exception as e:
        print("❌ Failed to send email:", e)

# Example usage (can be deleted or commented if importing into another script)
if __name__ == "__main__":
    send_email_alert(
        subject="Test Alert",
        body="This is a test email from your script.",
        to_email="recipient@example.com",
        from_email="your_email@gmail.com",
        from_password="your_password"
    )