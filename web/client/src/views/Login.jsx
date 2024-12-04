import axios from 'axios';
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const Login = ({ initialEmail = "", initPassword = "" }) => {
    const [email, setEmail] = useState(initialEmail);
    const [password, setPassword] = useState(initPassword);
    const [error, setError] = useState(null);
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate() ; 

    const submitLogin = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError(null);

        try {
            const res = await axios.post('http://localhost:8000/api/login', { email, password }, { withCredentials: true });
           // console.log(res.data.message);
           navigate('/admin/main');
        } catch (err) {
            setError(err.response?.data?.message || 'Login failed. Please try again.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="d-flex justify-content-center align-items-center min-vh-100 bg-light">
            <form 
                onSubmit={submitLogin} 
                className="p-4 border rounded shadow-sm bg-white" 
                style={{ width: '350px' }}
            >
                <h2 className="text-center mb-4">Login</h2>
                {error && <p className="text-danger text-center">{error}</p>}
                <div className="mb-3">
                    <h5 className="text-start">Email:</h5>
                    <input 
                        type="email" 
                        name="email" 
                        id="email" 
                        value={email} 
                        onChange={(e) => setEmail(e.target.value)} 
                        required 
                        className="form-control" 
                        placeholder="Enter your email" 
                    />
                </div>
                <div className="mb-3">
                    <h5 className="text-start">Password:</h5>
                    <input 
                        type="password" 
                        name="password" 
                        id="password" 
                        value={password} 
                        onChange={(e) => setPassword(e.target.value)} 
                        required 
                        className="form-control" 
                        placeholder="Enter your password" 
                    />
                </div>
                <div className="text-center">
                    <button 
                        type="submit" 
                        className="btn btn-primary w-100" 
                        disabled={loading}
                    >
                        {loading ? 'Logging in...' : 'Login'}
                    </button>
                </div>
            </form>
        </div>
    );
    
};

export default Login;
