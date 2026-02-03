from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.user import UserCreate, UserRead
from app.services.user_service import create_user
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/users/", response_model=UserRead)
def create_user_route(user: UserCreate, db: Session = Depends(get_db)):
    return create_user(db, user)
