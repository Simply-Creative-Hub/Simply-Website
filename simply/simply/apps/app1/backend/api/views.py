from rest_framework.decorators import api_view
from rest_framework.response import Response
import sys
import os

# Add the cpp_modules directory to the Python path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'cpp_modules', 'build'))

# Import the C++ module
try:
    import cpp_calculator
except ImportError:
    # Fallback if the C++ module is not built
    class cpp_calculator:
        @staticmethod
        def add(a, b):
            return a + b
        
        @staticmethod
        def multiply(a, b):
            return a * b


@api_view(['GET'])
def hello_world(request):
    return Response({
        "message": "Hello from Django Backend!",
        "status": "success",
        "timestamp": "2024-01-01T00:00:00Z",
        "framework": "Django + SolidStart Integration"
    })


@api_view(['POST'])
def compute(request):
    try:
        a = float(request.data.get('a', 0))
        b = float(request.data.get('b', 0))
        operation = request.data.get('operation', 'add')
        
        if operation == 'add':
            result = cpp_calculator.add(a, b)
        elif operation == 'multiply':
            result = cpp_calculator.multiply(a, b)
        else:
            return Response({
                "error": f"Unsupported operation: {operation}",
                "status": "error"
            }, status=400)
        
        return Response({
            "result": result,
            "operation": operation,
            "a": a,
            "b": b,
            "status": "success"
        })
    except Exception as e:
        return Response({
            "error": str(e),
            "status": "error"
        }, status=500)
