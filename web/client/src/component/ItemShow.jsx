import axios from 'axios';
import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import Navbar from './Navbar';
import { Box, CircularProgress, Typography, Card, CardContent, CardMedia, Button } from '@mui/material';

const ItemShow = ({ getUser = () => {},setData }) => {
    const [item, setItem] = useState(null);
    const [loading, setLoading] = useState(true);
    const { id } = useParams();
    const navigate = useNavigate();

    const getItem = async () => {
        try {
            const response = await axios.get(`http://localhost:8000/api/items/${id}`, { withCredentials: true });
            setItem(response.data.item);
        } catch (err) {
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        getUser();
        getItem();
    }, []);


    const handleEdit = () => {
          setData([
            item.categoryId,
            item.name,
            item.price,
            item.description,
            item.availableNum,
            item.imageUrl,
          ]);
          navigate(`/admin/items/${id}`);
        }
      

    return (
        <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', p: 3 }}>
            <Navbar index={2} />
            {loading ? (
                <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', mt: 5 }}>
                    <CircularProgress color="primary" />
                    <Typography variant="h6" color="textSecondary" sx={{ mt: 2 }}>
                        Loading...
                    </Typography>
                </Box>
            ) : (
                item && (
                    <Card sx={{ maxWidth: 800, display: 'flex', flexDirection: { xs: 'column', md: 'row' }, mt: 4 }}>
                        <CardMedia
                            component="img"
                            height="400"
                            image={item.imageUrl}
                            alt={item.name}
                            sx={{ width: { xs: '100%', md: '60%' } }}
                        />
                        <CardContent sx={{ display: 'flex', flexDirection: 'column', justifyContent: 'center', p: 3 }}>
                            <Typography variant="h5" component="div" sx={{ mb: 2 }}>
                                {item.name}
                            </Typography>
                            <Typography variant="body1" color="text.secondary">
                                Price: ${item.price}
                            </Typography>
                            <Typography variant="body1" color="text.secondary" sx={{ mt: 1 }}>
                                Available Quantity: {item.availableNum}
                            </Typography>
                            <Typography variant="body1" color="text.secondary" sx={{ mt: 1 }}>
                                Description: {item.description}
                            </Typography>
                            <Button
                                variant="contained"
                                color="primary"
                                sx={{ mt: 2 }}
                                onClick={handleEdit}
                            >
                                Edit Item
                            </Button>
                        </CardContent>
                    </Card>
                )
            )}
        </Box>
    );
};

export default ItemShow;
