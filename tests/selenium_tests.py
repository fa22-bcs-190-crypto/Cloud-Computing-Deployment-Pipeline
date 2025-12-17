#!/usr/bin/env python3
"""
Selenium Automated Tests for Cloud Pipeline Application
"""

import time
import unittest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import TimeoutException, NoSuchElementException
import requests

class CloudPipelineTests(unittest.TestCase):
    """Test suite for Cloud Pipeline Application"""
    
    @classmethod
    def setUpClass(cls):
        """Set up the test environment"""
        # Configure Chrome options
        chrome_options = Options()
        chrome_options.add_argument("--headless")  # Run in headless mode
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--window-size=1920,1080")
        
        # Initialize WebDriver
        cls.driver = webdriver.Chrome(options=chrome_options)
        cls.driver.implicitly_wait(10)
        
        # Test configuration
        cls.base_url = "http://localhost"  # Change to your deployed URL
        cls.api_url = f"{cls.base_url}/api"
        
        print(f"Testing application at: {cls.base_url}")
    
    @classmethod
    def tearDownClass(cls):
        """Clean up after tests"""
        cls.driver.quit()
    
    def setUp(self):
        """Set up before each test"""
        self.driver.get(self.base_url)
        time.sleep(2)  # Allow page to load
    
    def test_01_homepage_loads(self):
        """Test Case 1: Verify homepage loads successfully"""
        print("\n=== Test 1: Homepage Loading ===")
        
        try:
            # Check if page title contains expected text
            self.assertIn("Cloud Deployment Pipeline", self.driver.title)
            print("✅ Page title is correct")
            
            # Check if main header is present
            header = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.TAG_NAME, "h1"))
            )
            self.assertIn("Cloud Deployment Pipeline", header.text)
            print("✅ Main header is present")
            
            # Check if task form is present
            task_form = self.driver.find_element(By.ID, "taskForm")
            self.assertTrue(task_form.is_displayed())
            print("✅ Task form is visible")
            
            # Check if task list container is present
            task_list = self.driver.find_element(By.ID, "taskList")
            self.assertTrue(task_list.is_displayed())
            print("✅ Task list container is visible")
            
            print("✅ Homepage loads successfully")
            
        except Exception as e:
            print(f"❌ Homepage loading failed: {str(e)}")
            self.fail(f"Homepage loading test failed: {str(e)}")
    
    def test_02_add_task_functionality(self):
        """Test Case 2: Verify task creation functionality"""
        print("\n=== Test 2: Add Task Functionality ===")
        
        try:
            # Find form elements
            title_input = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.ID, "taskTitle"))
            )
            description_input = self.driver.find_element(By.ID, "taskDescription")
            submit_button = self.driver.find_element(By.CSS_SELECTOR, "#taskForm button[type='submit']")
            
            # Test data
            test_title = "Selenium Test Task"
            test_description = "This task was created by Selenium automated test"
            
            # Fill out the form
            title_input.clear()
            title_input.send_keys(test_title)
            print(f"✅ Entered task title: {test_title}")
            
            description_input.clear()
            description_input.send_keys(test_description)
            print(f"✅ Entered task description: {test_description}")
            
            # Submit the form
            submit_button.click()
            print("✅ Submitted task form")
            
            # Wait for task to appear in the list
            time.sleep(3)
            
            # Check if task appears in the task list
            task_items = self.driver.find_elements(By.CLASS_NAME, "task-item")
            
            # Look for our test task
            task_found = False
            for task in task_items:
                if test_title in task.text:
                    task_found = True
                    print("✅ Test task found in task list")
                    break
            
            self.assertTrue(task_found, "Test task was not found in the task list")
            
            # Verify form was cleared
            self.assertEqual(title_input.get_attribute("value"), "")
            self.assertEqual(description_input.get_attribute("value"), "")
            print("✅ Form was cleared after submission")
            
            print("✅ Add task functionality works correctly")
            
        except Exception as e:
            print(f"❌ Add task test failed: {str(e)}")
            self.fail(f"Add task functionality test failed: {str(e)}")
    
    def test_03_api_health_check(self):
        """Test Case 3: Verify API health endpoint responds correctly"""
        print("\n=== Test 3: API Health Check ===")
        
        try:
            # Check health status on the page
            health_status = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.ID, "healthStatus"))
            )
            
            # Wait for health check to complete
            time.sleep(3)
            
            health_text = health_status.text
            print(f"Health status displayed: {health_text}")
            
            # Check if health status shows as healthy
            self.assertIn("Healthy", health_text)
            print("✅ Health status shows as healthy")
            
            # Also test the API directly
            try:
                response = requests.get(f"{self.base_url}/health", timeout=10)
                self.assertEqual(response.status_code, 200)
                
                health_data = response.json()
                self.assertIn("status", health_data)
                print(f"✅ API health endpoint returns: {health_data.get('status')}")
                
            except requests.exceptions.RequestException as e:
                print(f"⚠️ Direct API test failed (may be expected in containerized environment): {e}")
            
            print("✅ API health check passed")
            
        except Exception as e:
            print(f"❌ API health check failed: {str(e)}")
            self.fail(f"API health check test failed: {str(e)}")
    
    def test_04_deployment_status_display(self):
        """Test Case 4: Verify deployment pipeline status is displayed"""
        print("\n=== Test 4: Deployment Status Display ===")
        
        try:
            # Check if deployment info section is present
            deployment_section = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.CLASS_NAME, "deployment-info"))
            )
            self.assertTrue(deployment_section.is_displayed())
            print("✅ Deployment info section is visible")
            
            # Check pipeline stages
            stages = self.driver.find_elements(By.CLASS_NAME, "stage")
            self.assertGreaterEqual(len(stages), 4)  # Should have at least 4 stages
            print(f"✅ Found {len(stages)} pipeline stages")
            
            # Check specific stages
            expected_stages = ["Local Development", "Docker Container", "Azure AKS", "GitHub"]
            for expected_stage in expected_stages:
                stage_found = False
                for stage in stages:
                    if expected_stage in stage.text:
                        stage_found = True
                        print(f"✅ Found stage: {expected_stage}")
                        break
                self.assertTrue(stage_found, f"Stage '{expected_stage}' not found")
            
            # Check if at least one stage shows as completed
            completed_stages = self.driver.find_elements(By.CSS_SELECTOR, ".stage .status.completed")
            self.assertGreater(len(completed_stages), 0)
            print(f"✅ Found {len(completed_stages)} completed stages")
            
            print("✅ Deployment status display works correctly")
            
        except Exception as e:
            print(f"❌ Deployment status test failed: {str(e)}")
            self.fail(f"Deployment status display test failed: {str(e)}")
    
    def test_05_responsive_design(self):
        """Test Case 5: Verify responsive design works on different screen sizes"""
        print("\n=== Test 5: Responsive Design ===")
        
        try:
            # Test desktop size
            self.driver.set_window_size(1920, 1080)
            time.sleep(1)
            
            container = self.driver.find_element(By.CLASS_NAME, "container")
            self.assertTrue(container.is_displayed())
            print("✅ Desktop view works correctly")
            
            # Test tablet size
            self.driver.set_window_size(768, 1024)
            time.sleep(1)
            
            self.assertTrue(container.is_displayed())
            print("✅ Tablet view works correctly")
            
            # Test mobile size
            self.driver.set_window_size(375, 667)
            time.sleep(1)
            
            self.assertTrue(container.is_displayed())
            
            # Check if form is still usable on mobile
            title_input = self.driver.find_element(By.ID, "taskTitle")
            self.assertTrue(title_input.is_displayed())
            print("✅ Mobile view works correctly")
            
            # Reset to desktop size
            self.driver.set_window_size(1920, 1080)
            
            print("✅ Responsive design test passed")
            
        except Exception as e:
            print(f"❌ Responsive design test failed: {str(e)}")
            self.fail(f"Responsive design test failed: {str(e)}")

def run_tests():
    """Run all tests and generate report"""
    print("=" * 60)
    print("   SELENIUM AUTOMATED TESTING SUITE")
    print("   Cloud Pipeline Application")
    print("=" * 60)
    
    # Create test suite
    suite = unittest.TestLoader().loadTestsFromTestCase(CloudPipelineTests)
    
    # Run tests with detailed output
    runner = unittest.TextTestRunner(verbosity=2, stream=None)
    result = runner.run(suite)
    
    # Print summary
    print("\n" + "=" * 60)
    print("   TEST EXECUTION SUMMARY")
    print("=" * 60)
    print(f"Tests run: {result.testsRun}")
    print(f"Failures: {len(result.failures)}")
    print(f"Errors: {len(result.errors)}")
    print(f"Success rate: {((result.testsRun - len(result.failures) - len(result.errors)) / result.testsRun * 100):.1f}%")
    
    if result.failures:
        print("\nFAILURES:")
        for test, traceback in result.failures:
            print(f"- {test}: {traceback}")
    
    if result.errors:
        print("\nERRORS:")
        for test, traceback in result.errors:
            print(f"- {test}: {traceback}")
    
    print("=" * 60)
    
    return result.wasSuccessful()

if __name__ == "__main__":
    success = run_tests()
    exit(0 if success else 1)