import React, { useEffect, useState } from 'react';
import Navbar from '../component/Navbar';
import { useNavigate } from 'react-router-dom';
import { Box, Button, CircularProgress, Typography } from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import { Grid, _ } from 'gridjs-react';
import axios from 'axios';
import { toast } from 'react-toastify';

import "../style/button.css";

const OrdersPage = ({ user, getUser = () => {}, setData }) => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  const getOrders = async () => {
    try {
      const response = await axios.get('http://localhost:8000/api/orders', { withCredentials: true });
      setOrders(response.data.orders);
    } catch (error) {
      console.error('Error fetching orders:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    getUser();
    getOrders();
  }, []);

  const handleAdd = () => {
    navigate(`/admin/orders/new`);
  };

  const handleEdit = (id) => {
    const order =  orders.find((order) => order._id === id);
    if (order) {
      setData([
        order._id,
      ]);}
    navigate(`/admin/orders/${id}`);
  };

  const handleShip = async (id, index) => {
    try {
      const response = await axios.patch(`http://localhost:8000/api/orders/${id}/ship`, {}, { withCredentials: true });
      const updatedOrders = [...orders];
      updatedOrders[index].status = 'Shipped';
      setOrders(updatedOrders);
      toast.success('Order shipped successfully');
    } catch (error) {
      console.error('Error shipping order:', error);
      toast.error('Failed to ship order');
    }
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`http://localhost:8000/api/orders/${id}`, { withCredentials: true });
      setOrders(orders.filter((order) => order._id !== id));
      toast.success('Order deleted successfully');
    } catch (error) {
      console.error('Error deleting order:', error);
      toast.error('Failed to delete order');
    }
  };

  const formatDataForGrid = () => {
    return orders.map((order, index) => [
      index + 1,
      order._id,
      order.orderDate,
      order.status,
      _(
        <div style={{ display: 'flex', gap: '0.5rem' }}>
          {
            order.status === "Pending" ? 
            <>
            <button
            onClick={() => handleEdit(order._id)}
            className='delete-btn edit'
            aria-label='Edit Order'
          >
            Edit
          </button>
          <button
            onClick={() => handleDelete(order._id)}
            className='delete-btn delete'
            aria-label='Delete Order'
          >
            Delete
          </button>
          <button
            onClick={() => handleShip(order._id, index)}
            className='delete-btn ship'
            aria-label='Ship Order'
            >
            Ship
          </button>
            </>
            :
            <></>
          }
          
        </div>
      ),
    ]);
  };

  return (
    <div>
      <Navbar index={3} />
      {loading ? (
        <Box display="flex" justifyContent="center" alignItems="center" height="60vh">
          <CircularProgress />
        </Box>
      ) : (
        <Box m={5} display="flex" flexDirection="column" alignItems="center">
          <Typography variant="h4" gutterBottom>Orders Table</Typography>
          <Button
            variant="contained"
            color="primary"
            startIcon={<AddIcon />}
            onClick={handleAdd}
            sx={{ mb: 3 }}
          >
            Add New Order
          </Button>
          <Grid
            data={formatDataForGrid()}
            columns={[
              { name: '#', align: 'center' },
              { name: 'Order ID', align: 'center' },
              { name: 'Order Date', align: 'center' },
              { name: 'Status', align: 'center' },
              { name: 'Actions', align: 'center' }
            ]}
            pagination={{ limit: 20 }}
            search={true}
            sort={true}
            style={{
              table: { border: '1px solid #e0e0e0' },
              th: { backgroundColor: '#f5f5f5', fontWeight: 'bold' },
            }}
          />
        </Box>
      )}
    </div>
  );
};

export default OrdersPage;
