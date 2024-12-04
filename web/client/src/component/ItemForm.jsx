import React, { useEffect, useState } from 'react';
import Navbar from './Navbar';
import { Box, TextField, Button, Typography, Select, MenuItem, FormControl, InputLabel } from '@mui/material';
import ImageUpload from './ImageUpload';
import axios from 'axios';
import { useNavigate, useParams } from 'react-router-dom';
import { toast } from 'react-toastify';

const ItemForm = ({
  initialName = "",
  initialNameAr="" ,
  initialPrice = 1,
  initialDescription = "",
  initialAvailableNum = 1,
  initialImageUrl = "",
  initialCategoryId = "",
  isUpdate = false,
  getUser = () => {}
}) => {
  const [name, setName] = useState(initialName);
  const [name_ar, setNameAr] = useState(initialNameAr);
  const [price, setPrice] = useState(initialPrice);
  const [description, setDescription] = useState(initialDescription);
  const [availableNum, setAvailableNum] = useState(initialAvailableNum);
  const [imageUrl, setImageUrl] = useState(initialImageUrl);
  const [categoryId, setCategoryId] = useState(initialCategoryId);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [errors, setErrors] = useState({});
  const [error, setError] = useState("");

  const navigate = useNavigate();
  const { id } = useParams();

  const handleCategories = async () => {
    try {
      const res = await axios.get("http://localhost:8000/api/categories", { withCredentials: true });
      setCategories(res.data.categories);
    } catch (err) {
      setError("Failed to load categories.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    getUser();
    handleCategories();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const url = `http://localhost:8000/api/items${isUpdate ? `/${id}` : ''}`;
    const method = isUpdate ? axios.patch : axios.post;

    try {
      const res = await method(url, { name,name_ar, price, description,availableNum, imageUrl, categoryId }, { withCredentials: true });
      toast.success(`Item ${isUpdate ? 'updated' : 'created'} successfully!`);
      navigate('/admin/items');
    } catch (err) {

      //console.log(err);
      const errorResponse = err.response?.data?.error?.errors || {};
      const newErrors = {};

      Object.keys(errorResponse).forEach((key) => {
        newErrors[key] = errorResponse[key].message;
      });

      setErrors(newErrors);
      setError("Error occurred while submitting the form. Please check the fields.");
    }
  };

  return (
    <>
      <Navbar index={2} />
      {loading ? (
        <h1>Loading...</h1>
      ) : (
        <div style={{ background: 'linear-gradient(135deg, #e3f2fd, #bbdefb)', minHeight: '100vh', padding: '20px' }}>
          <Box
            component="form"
            onSubmit={handleSubmit}
            sx={{
              maxWidth: 500,
              marginTop: 10,
              mx: 'auto',
              p: 4,
              display: 'flex',
              flexDirection: 'column',
              gap: 2,
              boxShadow: 6,
              borderRadius: 3,
              backgroundColor: 'rgba(255, 255, 255, 0.9)',
            }}
          >
            <Typography variant="h5" component="h1" align="center" gutterBottom style={{ color: '#1976d2', fontWeight: 'bold' }}>
              {isUpdate ? "Update Item" : "Create Item"}
            </Typography>

            <FormControl fullWidth error={!!errors.categoryId}>
              <InputLabel style={{ color: '#1976d2' }}>Select category</InputLabel>
              <Select
                value={categoryId}
                onChange={(e) => setCategoryId(e.target.value)}
                displayEmpty
                required
                style={{ color: '#1976d2' }}
              >
                <MenuItem value="">
                  <em>Select category</em>
                </MenuItem>
                {categories.map((category) => (
                  <MenuItem key={category._id} value={category._id}>
                    {category.name_en}
                  </MenuItem>
                ))}
              </Select>
              {errors.categoryId && <Typography color="error">{errors.categoryId}</Typography>}
            </FormControl>

            <TextField
              label="Name"
              variant="outlined"
              value={name}
              onChange={(e) => setName(e.target.value)}
              error={!!errors.name}
              helperText={errors.name}
              fullWidth
              required
              InputLabelProps={{ style: { color: '#1976d2' } }}
            />

<TextField
              label="الاسم"
              variant="outlined"
              value={name_ar}
              onChange={(e) => setNameAr(e.target.value)}
              error={!!errors.name_ar}
              helperText={errors.name_ar}
              fullWidth
              required
              InputLabelProps={{ style: { color: '#1976d2' } }}
            />

            <TextField
              label="Price"
              variant="outlined"
              type="number"
              value={price}
              onChange={(e) => setPrice(Number(e.target.value))}
              error={!!errors.price}
              helperText={errors.price}
              fullWidth
              required
              InputLabelProps={{ style: { color: '#1976d2' } }}
            />

            <TextField
              label="Description"
              variant="outlined"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              error={!!errors.description}
              helperText={errors.description}
              fullWidth
              InputLabelProps={{ style: { color: '#1976d2' } }}
            />

            <TextField
              label="Available Number"
              variant="outlined"
              type="number"
              value={availableNum}
              onChange={(e) => setAvailableNum(Number(e.target.value))}
              error={!!errors.availableNum}
              helperText={errors.availableNum}
              fullWidth
              InputLabelProps={{ style: { color: '#1976d2' } }}
            />

            <ImageUpload getUser={getUser} imageUrl={imageUrl} error={errors.imageUrl} setImageUrl={setImageUrl} />

            <Button
              type="submit"
              variant="contained"
              color="primary"
              sx={{
                mt: 2,
                backgroundColor: '#1976d2',
                color: 'white',
                fontWeight: 'bold',
                '&:hover': {
                  backgroundColor: '#1565c0',
                }
              }}
              fullWidth
            >
              {isUpdate ? "Update" : "Create"}
            </Button>
            {error && <Typography color="error" align="center">{error}</Typography>}
          </Box>
        </div>
      )}
    </>
  );
};

export default ItemForm;
