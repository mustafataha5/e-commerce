import React, { useEffect, useState } from "react";
import axios from "axios";
import Navbar from "./Navbar";
import { Box, Button, IconButton, MenuItem, Select, TextField, Typography } from '@mui/material';
import PlusOneOutlinedIcon from '@mui/icons-material/PlusOneOutlined';
import IndeterminateCheckBoxOutlinedIcon from '@mui/icons-material/IndeterminateCheckBoxOutlined';
import { useNavigate, useParams } from "react-router-dom";
import { toast } from "react-toastify";

const OrderForm = ({ user, getUser, isUpdate = false }) => {
  const [userId, setUserId] = useState("");
  const [selectedItems, setSelectedItems] = useState([{ itemId: "", quantity: 1 }]);
  const [items, setItems] = useState([]);
  const [status, setStatus] = useState("Pending");
  const [loading, setLoading] = useState(true); // State for loading indicator
  
  const navigate = useNavigate();
  const { id } = useParams();

  // Fetch the user information
  const getUserInfo = async () => {
    await getUser();
  };

  // Fetch available items for the order form
  const getItems = async () => {
    try {
      const response = await axios.get('http://localhost:8000/api/items', { withCredentials: true });
      setItems(response.data.items);
    } catch (error) {
      console.error('Error fetching items:', error);
      toast.error('Failed to fetch items.');
    }
  };

  // Fetch selected items for the order if updating
  const getSelectedItem = async () => {
    try {
      const response = await axios.get(`http://localhost:8000/api/orders/${id}`, { withCredentials: true });
      setSelectedItems(response.data.order.items);
    } catch (error) {
      console.error('Error fetching order items:', error);
      toast.error('Failed to fetch order items.');
    }
  };

  useEffect(() => {
    getUserInfo();
    getItems();
    if (isUpdate) {
      getSelectedItem();
    }
    setLoading(false); // Set loading to false after data is fetched
  }, [isUpdate, id]);

  useEffect(() => {
    if (user) {
      setUserId(user._id); // Assuming user has an '_id' field
    }
  }, [user]);

  const handleUserIdChange = (e) => {
    setUserId(e.target.value);
  };

  const handleStatusChange = (e) => {
    setStatus(e.target.value);
  };

  const handleItemChange = (index, field, value) => {
    const updatedItems = [...selectedItems];
    updatedItems[index][field] = value;
    setSelectedItems(updatedItems);
  };

  const addItem = () => {
    setSelectedItems([...selectedItems, { itemId: "", quantity: 1 }]);
  };

  const removeItem = (index) => {
    setSelectedItems(selectedItems.filter((_, i) => i !== index));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    const orderData = {
      userId,
      items: selectedItems,
      status,
    };

    try {
      const response = await axios.post("http://localhost:8000/api/orders", orderData, { withCredentials: true });
      toast.success(`Order ${isUpdate ? 'updated' : 'created'} successfully!`);
      navigate('/admin/orders');
    } catch (error) {
      console.error("Error creating order:", error);
      toast.error('Failed to create order');
    }
  };

  if (loading) {
    return <h1>Loading...</h1>;
  }

  return (
    <>
      <Navbar index={3} />
      <Box
        component="form"
        onSubmit={handleSubmit}
        sx={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          padding: 3,
          backgroundColor: '#f5f5f5',
          borderRadius: 2,
          boxShadow: 3,
          maxWidth: 500,
          margin: 'auto',
          mt: 5,
        }}
      >
        <Typography variant="h4" gutterBottom>
          {isUpdate ? 'Update Order' : 'Create Order'}
        </Typography>

        <TextField
          label="User ID"
          variant="outlined"
          value={userId}
          onChange={handleUserIdChange}
          required
          fullWidth
          margin="normal"
        />

        <Typography variant="h6" sx={{ mt: 2 }}>
          Order Items
        </Typography>
        {selectedItems.map((selectedItem, index) => (
          <Box
            key={index}
            sx={{
              display: 'flex',
              alignItems: 'center',
              gap: 2,
              mb: 2,
              width: '100%',
            }}
          >
            <Select
              label="Item"
              value={selectedItem.itemId}
              onChange={(e) => handleItemChange(index, "itemId", e.target.value)}
              displayEmpty
              fullWidth
              required
            >
              <MenuItem value="">
                <em>Select an item</em>
              </MenuItem>
              {items.map((item) => (
                <MenuItem key={item._id} value={item._id}>
                  {item.name} (Available: {item.availableNum})
                </MenuItem>
              ))}
            </Select>

            <TextField
              label="Quantity"
              type="number"
              variant="outlined"
              value={selectedItem.quantity}
              onChange={(e) => handleItemChange(index, "quantity", Math.max(1, Math.min(e.target.value, items.find(item => item._id === selectedItem.itemId)?.availableNum || 1)))}
              InputProps={{
                inputProps: {
                  min: 1,
                  max: items.find(item => item._id === selectedItem.itemId)?.availableNum || 1,
                },
              }}
              fullWidth
            />

            <IconButton onClick={() => removeItem(index)} color="secondary">
              <IndeterminateCheckBoxOutlinedIcon />
            </IconButton>
            
          </Box>
        ))}
        <IconButton onClick={addItem} color="primary">
          <PlusOneOutlinedIcon />
        </IconButton>

        {/* Uncomment this part if you want to allow status modification */}
        {/* <TextField
          label="Order Status"
          select
          value={status}
          onChange={handleStatusChange}
          variant="outlined"
          fullWidth
          margin="normal"
        >
          <MenuItem value="Pending">Pending</MenuItem>
          <MenuItem value="Shipped">Shipped</MenuItem>
          <MenuItem value="Delivered">Delivered</MenuItem>
        </TextField> */}

        <Button
          type="submit"
          variant="contained"
          color="primary"
          sx={{ mt: 3 }}
          fullWidth
        >
          {isUpdate ? 'Update Order' : 'Create Order'}
        </Button>
      </Box>
    </>
  );
};

export default OrderForm;
