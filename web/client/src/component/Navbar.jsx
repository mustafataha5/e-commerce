import React from 'react';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import MenuIcon from '@mui/icons-material/Menu';
import { Box } from '@mui/material';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';



const Navbar = ({ index = 0, }) => {


    const navigate = useNavigate();

    const logoutUser = (e) => {
        e.preventDefault();
        axios.post("http://localhost:8000/api/logout", {}, { withCredentials: true })
            .then((res) => {
                console.log(res.response)
                navigate("/login")
            })
            .catch((err) => console.log(err));
    }

    const toHome = (e) => {
        e.preventDefault();
        navigate('/admin/main')
    };
    const toCategories = (e) => {
        e.preventDefault();
        navigate('/admin/categories')
    };
    const toItems = (e) => {
        e.preventDefault();
        navigate('/admin/items')
    };
    const toOrders = (e) => {
        e.preventDefault();
        navigate('/admin/orders')
    };
    const toUsers = (e) => {
        e.preventDefault();
        navigate('/admin/users')
    };

    return (
        <AppBar position="sticky" color="primary">
            <Toolbar>
                {/* Menu Icon for mobile view */}
                <IconButton edge="start" color="inherit" aria-label="menu" sx={{ mr: 2, display: { xs: 'block', md: 'none' } }}>
                    <MenuIcon />
                </IconButton>

                {/* Logo or Brand Name */}
                <Typography variant="h6" sx={{ flexGrow: 1 }}>
                    Istanbul Mall Admin
                </Typography>

                {/* Navigation Links - Hidden on mobile */}
                <Box sx={{ display: { xs: 'none', md: 'flex' }, gap: 2 }}>
                    <Button
                        sx={{
                            backgroundColor: index === 0 ? 'primary.light' : 'transparent',
                            color: index === 0 ? 'white' : 'inherit',
                            borderRadius: 1,
                            '&:hover': {
                                backgroundColor: 'primary.dark' , // Change color on hover
                            },
                        }}
                        onClick={toHome}
                    >
                        Home
                    </Button>
                    <Button
                        sx={{
                            backgroundColor: index === 1 ? 'primary.light' : 'transparent',
                            color: index === 1 ? 'white' : 'inherit',
                            borderRadius: 1,
                            '&:hover': {
                                backgroundColor: 'primary.dark',
                            },
                        }}
                        onClick={toCategories}
                    >
                        Categories
                    </Button>
                    <Button
                        sx={{
                            backgroundColor: index === 2 ? 'primary.light' : 'transparent',
                            color: index === 2 ? 'white' : 'inherit',
                            borderRadius: 1,
                            '&:hover': {
                                backgroundColor:  'primary.dark',
                            },
                        }}
                        onClick={toItems}
                    >
                        Items
                    </Button>
                    <Button
                        sx={{
                            backgroundColor: index === 3 ? 'primary.light' : 'transparent',
                            color: index === 3 ? 'white' : 'inherit',
                            borderRadius: 1,
                            '&:hover': {
                                backgroundColor: 'primary.dark' ,
                            },
                        }}
                        onClick={toOrders}
                    >
                        Orders
                    </Button>
                    <Button
                        sx={{
                            backgroundColor: index === 4 ? 'primary.light' : 'transparent',
                            color: index === 4 ? 'white' : 'inherit',
                            borderRadius: 1,
                            '&:hover': {
                                backgroundColor: 'primary.dark',
                            },
                        }}
                        onClick={toUsers}
                    >
                        Users
                    </Button>
                    <Button
                        sx={{
                            backgroundColor: index === 5 ? 'error.main' : 'transparent',
                            color: index === 5 ? 'white' : 'inherit',
                            borderRadius: 1,
                            '&:hover': {
                                backgroundColor:'error.dark',
                            },
                        }}
                        onClick={logoutUser}
                    >
                        Logout
                    </Button>
                </Box>
            </Toolbar>
        </AppBar>
    );
};

export default Navbar;
