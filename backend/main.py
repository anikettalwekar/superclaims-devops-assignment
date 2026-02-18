from fastapi import FastAPI
from celery.result import AsyncResult
from worker import write_log_celery
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/notify/")
async def notify_user(email: str):
    task = write_log_celery.delay(f"Notification sent to {email}")
    return {"message": f"Email will be sent to {email}", "task_id": task.id}

@app.get("/task_status/{task_id}")
async def get_task_status(task_id: str):
    task_result = AsyncResult(task_id)

    if task_result.ready():
        return {
            "task_id": task_id,
            "status": "completed",
            "result": task_result.result
        }
    elif task_result.failed():
        return {"task_id": task_id, "status": "failed"}
    else:
        return {"task_id": task_id, "status": "in progress"}

@app.post("/health/")
async def health():
    return {"message": "OK"}
