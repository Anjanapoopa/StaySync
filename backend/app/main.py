from fastapi import FastAPI, HTTPException, Depends
from sqlalchemy.orm import Session
from .database import engine, SessionLocal
from .models import User, Base
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware


# ---------- CREATE TABLE ----------
Base.metadata.create_all(bind=engine)

# ---------- CREATE APP ----------
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # allow Flutter web
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ---------- DB SESSION ----------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ---------- SCHEMAS ----------
class UserRegister(BaseModel):
    email: str
    password: str
    role: str

class UserLogin(BaseModel):
    email: str
    password: str

# ---------- ROUTES ----------
@app.get("/")
def home():
    return {"message": "StaySync backend is running"}

@app.post("/register")
def register(user: UserRegister, db: Session = Depends(get_db)):
    existing_user = db.query(User).filter(User.email == user.email).first()

    if existing_user:
        raise HTTPException(status_code=400, detail="User already exists")

    new_user = User(
        email=user.email,
        password=user.password,
        role=user.role
    )

    db.add(new_user)
    db.commit()

    return {"message": "User registered successfully"}

@app.post("/login")
def login(user: UserLogin, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.email == user.email).first()

    if not db_user or db_user.password != user.password:
        raise HTTPException(status_code=400, detail="Invalid credentials")

    return {
        "access_token": "dummy_token",
        "email": db_user.email,
        "role": db_user.role
    }
