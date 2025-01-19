from dotenv import load_dotenv
import os
from twilio.rest import Client
import logging
import re

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load environment variables from .env file
load_dotenv()

# Initialize Twilio client
client = Client(
    os.environ.get('TWILIO_ACCOUNT_SID'),
    os.environ.get('TWILIO_AUTH_TOKEN')
)

def format_phone_number(phone):
    """
    Format phone number to ensure proper country code
    
    Args:
        phone (str): Phone number to format
    Returns:
        str: Formatted phone number with proper country code
    """
    try:
        # Remove any non-digit characters
        phone = re.sub(r'\D', '', phone)
        
        # If number starts with '0', remove it
        if phone.startswith('0'):
            phone = phone[1:]
        
        # If number starts with '91', remove it
        if phone.startswith('91'):
            phone = phone[2:]
        
        # If number starts with '+91', remove it
        if phone.startswith('+91'):
            phone = phone[3:]
            
        # Ensure the number is 10 digits
        if len(phone) != 10:
            raise ValueError(f"Invalid phone number length: {phone}")
            
        # Add Indian country code
        return f"+91{phone}"
    except Exception as e:
        logger.error(f"Error formatting phone number '{phone}': {str(e)}")
        raise ValueError(f"Invalid phone number format: {phone}")

def send_sms(to, message):
    """
    Sends an SMS message using Twilio.
    
    Args:
        to (str): Recipient's phone number.
        message (str): Message content.
    Returns:
        dict: Response with status and details
    """
    try:
        # Format phone number
        formatted_number = format_phone_number(to)
        logger.info(f"Sending SMS to {formatted_number}")
        
        response = client.messages.create(
            body=message,
            from_=os.environ.get('TWILIO_PHONE_NUMBER'),
            to=formatted_number
        )
        logger.info(f"Successfully sent SMS to {formatted_number} with SID: {response.sid}")
        return {
            'status': 'success',
            'message': 'SMS sent successfully',
            'sid': response.sid
        }
    except ValueError as e:
        error_msg = str(e)
        logger.error(f"Invalid phone number format: {error_msg}")
        return {
            'status': 'error',
            'message': f"Invalid phone number: {error_msg}",
            'phone': to
        }
    except Exception as e:
        error_msg = str(e)
        logger.error(f"Failed to send SMS to {to}: {error_msg}")
        
        # Handle unverified number in trial account
        if "unverified" in error_msg.lower():
            return {
                'status': 'warning',
                'message': 'Number not verified in trial account',
                'phone': to
            }
        
        return {
            'status': 'error',
            'message': error_msg,
            'phone': to
        }

def make_call(to, script):
    """
    Makes an automated voice call using Twilio.
    
    Args:
        to (str): Recipient's phone number.
        script (str): Script to be read during the call.
    Returns:
        dict: Response with status and details
    """
    try:
        # Format phone number
        formatted_number = format_phone_number(to)
        logger.info(f"Initiating call to {formatted_number}")
        
        twiml = f"""
        <Response>
            <Say>{script}</Say>
        </Response>
        """
        response = client.calls.create(
            twiml=twiml,
            from_=os.environ.get('TWILIO_PHONE_NUMBER'),
            to=formatted_number
        )
        logger.info(f"Successfully initiated call to {formatted_number} with SID: {response.sid}")
        return {
            'status': 'success',
            'message': 'Call initiated successfully',
            'sid': response.sid
        }
    except ValueError as e:
        error_msg = str(e)
        logger.error(f"Invalid phone number format: {error_msg}")
        return {
            'status': 'error',
            'message': f"Invalid phone number: {error_msg}",
            'phone': to
        }
    except Exception as e:
        error_msg = str(e)
        logger.error(f"Failed to make call to {to}: {error_msg}")
        
        # Handle unverified number in trial account
        if "unverified" in error_msg.lower():
            return {
                'status': 'warning',
                'message': 'Number not verified in trial account',
                'phone': to
            }
        
        return {
            'status': 'error',
            'message': error_msg,
            'phone': to
        }

def send_emergency_notifications(user_name, contacts, location_url=None, message=None):
    """
    Send emergency notifications to all contacts.
    
    Args:
        user_name (str): Name of the user in emergency
        contacts (list): List of contact dictionaries with phone_number
        location_url (str, optional): URL to track location
        message (str, optional): Additional message
    Returns:
        dict: Summary of notification attempts
    """
    results = {
        'sms_sent': 0,
        'calls_made': 0,
        'failures': [],
        'warnings': []
    }
    
    for contact in contacts:
        phone = contact.get('phone_number')
        if not phone:
            continue
            
        # Prepare messages
        sms_message = f"EMERGENCY SOS from {user_name}!\n"
        if location_url:
            sms_message += f"Location: {location_url}\n"
        if message:
            sms_message += f"Message: {message}"
            
        call_script = f"Emergency alert! {user_name} has triggered an SOS alert. Please check your SMS for details and location."
        
        # Send SMS
        sms_result = send_sms(phone, sms_message)
        if sms_result['status'] == 'success':
            results['sms_sent'] += 1
        elif sms_result['status'] == 'warning':
            results['warnings'].append({
                'type': 'sms',
                'phone': phone,
                'message': sms_result['message']
            })
        else:
            results['failures'].append({
                'type': 'sms',
                'phone': phone,
                'error': sms_result['message']
            })
        
        # Make call
        call_result = make_call(phone, call_script)
        if call_result['status'] == 'success':
            results['calls_made'] += 1
        elif call_result['status'] == 'warning':
            results['warnings'].append({
                'type': 'call',
                'phone': phone,
                'message': call_result['message']
            })
        else:
            results['failures'].append({
                'type': 'call',
                'phone': phone,
                'error': call_result['message']
            })
    
    return results

def generate_live_location_url(token):
    """
    Generates a unique URL for tracking live location.

    Args:
        token (UUID): Unique token associated with the SOSRequest.

    Returns:
        str: A unique tracking URL.
    """
    base_url = os.environ.get('BASE_URL', 'http://localhost:8000')  # Ensure BASE_URL is set in your environment
    return f"{base_url}/track/{token}/"