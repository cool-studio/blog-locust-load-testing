from locust import HttpLocust, Locust, TaskSet, task, between

class MyTaskSet(TaskSet):
    @task(1)
    def get_home(self):
        self.client.get('/')
        print("Getting homepage")
    
    @task(2)
    def login_as_admin(self):
        self.client.post('/login', {"user":"admin","password":"admin","email":""})
        print("Logging in as admin")


class User(HttpLocust):
    task_set = MyTaskSet
    wait_time = between(1, 5)
