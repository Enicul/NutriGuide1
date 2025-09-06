#!/usr/bin/env python3
"""
Comprehensive Test Runner for Spark Food Recommendation System
Sets up test environment, creates test data, and runs all tests
"""

import subprocess
import sys
import os
import time
import requests
import json
from pathlib import Path

def run_command(command, cwd=None, check=True):
    """Run a command and return the result"""
    print(f"🔧 Running: {command}")
    try:
        result = subprocess.run(
            command, 
            shell=True, 
            cwd=cwd, 
            check=check, 
            capture_output=True, 
            text=True
        )
        if result.stdout:
            print(f"   Output: {result.stdout.strip()}")
        return result
    except subprocess.CalledProcessError as e:
        print(f"   Error: {e.stderr}")
        if check:
            raise
        return e

def check_server_health():
    """Check if the server is running and healthy"""
    try:
        response = requests.get("http://localhost:8000/", timeout=5)
        return response.status_code == 200
    except:
        return False

def setup_test_environment():
    """Set up the complete test environment"""
    print("🚀 Setting up Spark Food Recommendation System Test Environment")
    print("=" * 60)
    
    # Get the project root directory
    project_root = Path(__file__).parent
    backend_dir = project_root / "backend"
    frontend_dir = project_root / "frontend"
    
    print(f"📁 Project root: {project_root}")
    print(f"📁 Backend dir: {backend_dir}")
    print(f"📁 Frontend dir: {frontend_dir}")
    
    # Step 1: Create test database
    print("\n1️⃣ Creating test database...")
    try:
        run_command("python db/test_data.py", cwd=backend_dir)
        print("   ✅ Test database created successfully")
    except Exception as e:
        print(f"   ❌ Failed to create test database: {e}")
        return False
    
    # Step 2: Install backend dependencies
    print("\n2️⃣ Installing backend dependencies...")
    try:
        run_command("pip install -r requirements.txt", cwd=backend_dir)
        print("   ✅ Backend dependencies installed")
    except Exception as e:
        print(f"   ❌ Failed to install backend dependencies: {e}")
        return False
    
    # Step 3: Start backend server
    print("\n3️⃣ Starting backend server...")
    try:
        # Kill any existing server
        run_command("pkill -f 'python main.py'", check=False)
        time.sleep(1)
        
        # Start server in background
        run_command("nohup python main.py > server.log 2>&1 &", cwd=backend_dir)
        print("   ✅ Backend server started")
        
        # Wait for server to be ready
        print("   ⏳ Waiting for server to be ready...")
        for i in range(30):  # Wait up to 30 seconds
            if check_server_health():
                print("   ✅ Server is ready!")
                break
            time.sleep(1)
        else:
            print("   ❌ Server failed to start within 30 seconds")
            return False
            
    except Exception as e:
        print(f"   ❌ Failed to start backend server: {e}")
        return False
    
    # Step 4: Install frontend dependencies
    print("\n4️⃣ Installing frontend dependencies...")
    try:
        run_command("npm install", cwd=frontend_dir)
        print("   ✅ Frontend dependencies installed")
    except Exception as e:
        print(f"   ❌ Failed to install frontend dependencies: {e}")
        return False
    
    # Step 5: Start frontend development server
    print("\n5️⃣ Starting frontend development server...")
    try:
        # Kill any existing frontend server
        run_command("pkill -f 'vite'", check=False)
        time.sleep(1)
        
        # Start frontend server in background
        run_command("nohup npm run dev > frontend.log 2>&1 &", cwd=frontend_dir)
        print("   ✅ Frontend server started")
        
        # Wait for frontend to be ready
        print("   ⏳ Waiting for frontend to be ready...")
        time.sleep(5)  # Give frontend time to start
        
    except Exception as e:
        print(f"   ❌ Failed to start frontend server: {e}")
        return False
    
    print("\n🎉 Test environment setup complete!")
    return True

def run_comprehensive_tests():
    """Run comprehensive tests"""
    print("\n🧪 Running Comprehensive Tests")
    print("=" * 60)
    
    backend_dir = Path(__file__).parent / "backend"
    
    try:
        # Run the comprehensive test script
        run_command("python test_comprehensive.py", cwd=backend_dir)
        print("\n✅ All tests completed successfully!")
        return True
    except Exception as e:
        print(f"\n❌ Tests failed: {e}")
        return False

def run_frontend_tests():
    """Run frontend tests"""
    print("\n🎨 Testing Frontend Interface")
    print("=" * 60)
    
    frontend_dir = Path(__file__).parent / "frontend"
    
    try:
        # Check if frontend is accessible
        print("   ⏳ Checking frontend accessibility...")
        time.sleep(2)
        
        # Try to access the frontend
        try:
            response = requests.get("http://localhost:5173/", timeout=10)
            if response.status_code == 200:
                print("   ✅ Frontend is accessible at http://localhost:5173")
                print("   🌐 You can now test the interface in your browser!")
                return True
            else:
                print(f"   ❌ Frontend returned status code: {response.status_code}")
                return False
        except Exception as e:
            print(f"   ❌ Frontend not accessible: {e}")
            return False
            
    except Exception as e:
        print(f"   ❌ Frontend test failed: {e}")
        return False

def show_test_summary():
    """Show test summary and next steps"""
    print("\n📊 Test Summary")
    print("=" * 60)
    print("✅ Backend server running on http://localhost:8000")
    print("✅ Frontend interface running on http://localhost:5173")
    print("✅ Test database created with realistic data")
    print("✅ All API endpoints tested")
    print("✅ User flows simulated")
    print("✅ Error handling verified")
    
    print("\n🎯 Next Steps:")
    print("1. Open http://localhost:5173 in your browser")
    print("2. Test the food recommendation interface")
    print("3. Try different user preferences and health contexts")
    print("4. Test meal analysis functionality")
    print("5. Check the API documentation at http://localhost:8000/docs")
    
    print("\n📋 Available Test Data:")
    print("- 18 different foods across all categories")
    print("- 5 test users with different preferences")
    print("- 30 days of consumption history")
    print("- Realistic nutrition goals and health contexts")
    
    print("\n🔧 To stop the servers:")
    print("   pkill -f 'python main.py'  # Stop backend")
    print("   pkill -f 'vite'            # Stop frontend")

def cleanup():
    """Clean up test environment"""
    print("\n🧹 Cleaning up test environment...")
    try:
        run_command("pkill -f 'python main.py'", check=False)
        run_command("pkill -f 'vite'", check=False)
        print("   ✅ Servers stopped")
    except:
        pass

def main():
    """Main test runner"""
    print("🍎 Spark Food Recommendation System - Comprehensive Test Suite")
    print("=" * 80)
    
    try:
        # Setup test environment
        if not setup_test_environment():
            print("\n❌ Test environment setup failed!")
            return 1
        
        # Run comprehensive tests
        if not run_comprehensive_tests():
            print("\n❌ Comprehensive tests failed!")
            return 1
        
        # Test frontend
        if not run_frontend_tests():
            print("\n❌ Frontend tests failed!")
            return 1
        
        # Show summary
        show_test_summary()
        
        print("\n🎉 All tests completed successfully!")
        print("🚀 Your Spark Food Recommendation System is ready for testing!")
        
        return 0
        
    except KeyboardInterrupt:
        print("\n\n⏹️ Test interrupted by user")
        cleanup()
        return 1
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        cleanup()
        return 1

if __name__ == "__main__":
    sys.exit(main())
